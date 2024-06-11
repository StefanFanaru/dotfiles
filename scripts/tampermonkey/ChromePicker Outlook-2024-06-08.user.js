// ==UserScript==
// @name         ChromePicker Outlook
// @namespace    http://tampermonkey.net/
// @version      2024-06-08
// @description  try to take over the world!
// @author       You
// @match        https://outlook.office365.com/mail/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    function prependChromepickerToLinks(links) {
        links.forEach(link => {
            let currentHref = link.getAttribute('href');
            if (currentHref && !currentHref.includes('chromepicker')) {
                let newLink = document.createElement('a');

                link.setAttribute('href', 'chromepicker:' + currentHref);
            }


        });
    }

    prependChromepickerToLinks(document.querySelectorAll('a[target="_blank"]'));

    const observer = new MutationObserver((mutationsList) => {
        for (const mutation of mutationsList) {
            if (mutation.type === 'childList') {
                mutation.addedNodes.forEach(node => {
                    if (node.tagName === 'A') {
                        prependChromepickerToLinks([node]);
                    } else if (node.querySelectorAll) {
                        prependChromepickerToLinks(node.querySelectorAll('a'));
                    }
                });
            }
        }
    });

    // Start observing the document body for added nodes
    observer.observe(document.body, { childList: true, subtree: true });
})();