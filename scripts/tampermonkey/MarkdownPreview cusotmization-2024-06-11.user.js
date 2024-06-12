// ==UserScript==
// @name         MarkdownPreview cusotmization
// @namespace    http://tampermonkey.net/
// @version      2024-06-11
// @description  try to take over the world!
// @author       You
// @match        http://localhost:8199/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=undefined.localhost
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    setTimeout(()=> {

        const pageCtn = document.getElementById('page-ctn');
        pageCtn.style.margin = 'inherit'
        pageCtn.style.marginLeft = 'auto'

        document.getElementById('page-header').style.display = 'none';
        document.querySelector('.markdown-body').style.minHeight = 'calc(100vh - 92px)';
    }, 500)
    // Your code khere...
})();