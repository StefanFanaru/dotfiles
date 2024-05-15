" imports.vim
" define fold regions of imports, includes, etc for nvim
" which nvim_treesitter does not care
" support language:     keyword:
"       java            import
"       c/cpp           #include
"       python          import/from ... import
"       php             use
" Copyright (C) 2023 elementdavv<elementdavv@hotmail.com>
" Distributed under terms of the GPL3 license.
"

set foldtext=FoldText()
set fillchars=fold:\  " removes trailing dots. Mind that there is a whitespace after the \!

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" only fold the imports/usings statements when opening a file
set foldlevel=19

" language fold
au FileType java setlocal foldexpr=FileTypeExpr(v:lnum,'java')
au FileType c,cpp setlocal foldexpr=FileTypeExpr(v:lnum,'cpp')
au FileType python setlocal foldexpr=FileTypeExpr(v:lnum,'python')
au FileType php setlocal foldexpr=FileTypeExpr(v:lnum,'php')
au FileType cs setlocal foldexpr=FileTypeExpr(v:lnum,'cs')
au FileType typescript setlocal foldexpr=FileTypeExpr(v:lnum,'typescript')

" set debug=msg
function! FileTypeExpr( linenumber, ft ) abort
    " nvim_treesitter does not look block comments of java/php as fold regions
    " so we make it
    if ( a:ft == 'java' || a:ft == 'php' )
        let docexpr = DocExpr(a:linenumber)
        if ( docexpr != '0' )
            return docexpr
        endif
    endif

    " treat imports for any language
    let reg = ''
    if ( a:ft == 'java' )
        let reg = '^\s*import'
    elseif ( a:ft == 'cpp' )
        let reg = '^\s*#include'
    elseif ( a:ft == 'python' )
        let reg = '^\s*\(from.*\)\?import'
    elseif ( a:ft == 'php' )
        let reg = '^\s*use'
    elseif ( a:ft == 'cs' )
        let reg = '^\s*using'
    elseif ( a:ft == 'typescript' )
        let reg = '^\s*import'
    endif
    let importexpr = ImportExpr( a:linenumber, reg )
    if ( importexpr != '0' )
        return importexpr
    endif
    return nvim_treesitter#foldexpr()
endfunction

let s:hasdoc = 0
" check block comments
" return fold level, 0 if not handled
function! DocExpr( linenumber ) abort
    let aline = getline( a:linenumber )
    if ( aline =~ '^\s*/\*.*\*/$' )     " single line comment
        if ( s:hasdoc > 0 )             " continue inside a comment
            return '='
        else
            return '0'
        endif
    elseif ( aline =~ '^\s*/\*.*$' )    " start of doc fold
        let s:hasdoc += 1
        return "a1"
    elseif ( aline =~ '^\s*\*/\s*$' )   " end of doc fold
        let s:hasdoc -= 1
        return "s1"
    elseif ( s:hasdoc > 0 )             " continue of doc fold
        return '='
    endif
    return '0'
endfunction

let s:hasimport = 0
" check imports
" return fold level, 0 if not handled
function! ImportExpr( linenumber, reg ) abort
    let aline = getline( a:linenumber )
    if ( aline =~ a:reg )
        if ( s:hasimport == 1 )
            if (ImportContinued( a:linenumber, a:reg ))
                return '='                                  " in between imports
            else
                let s:hasimport = 0
                return 's20'                                 " last import
            endif
        else
            if (ImportContinued( a:linenumber, a:reg ))
                let s:hasimport = 1                         " create region for at least 2 imports
                return 'a20'
            else
                return '0'                                  " only 1 import, not create region
            endif
        endif
    endif
    if ( s:hasimport == 1 )
        return '='
    endif
    return '0'
endfunction

" check next line, blank lines ignored
" return 1 if continued else 0
function! ImportContinued( linenumber, reg ) abort
    let nextline = a:linenumber
    while(1)
        let nextline += 1
        let bline = getline( nextline )
        if ( bline =~ a:reg )
            return 1
        endif
        if ( bline =~ '^\s*$' )
            continue
        endif
        return 0
    endwhile
endfunction

" Custom text showing up when a fold is active
function FoldText()
	let line = getline(v:foldstart)
	let numOfLines = v:foldend - v:foldstart
    return '+--' . ' (' . numOfLines . ' L) ' . line
endfunction
