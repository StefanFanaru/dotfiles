skip_global_compinit=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
export EDITOR=nvim
export IS_ZSH=true
export BAT_THEME="CatppuccinMocha"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xsc)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
export FZF_TMUX_OPTS='-p80%,60%'
