// ==UserScript==
// @name         ChromePicker Teams (no-attachments)
// @namespace    http://tampermonkey.net/
// @version      2024-06-08
// @description  try to take over the world!
// @author       You
// @match        https://teams.microsoft.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  function prependChromepickerToLinks(links) {
    links.forEach((link) => {
      let currentHref = link.getAttribute("href");

      if (currentHref && !currentHref.includes("chromepicker")) {
        let newLink = document.createElement("a");
        newLink.setAttribute("href", "chromepicker:" + currentHref);
        newLink.setAttribute("target", "_blank");

        if (link.innerText) {
          newLink.innerText = link.innerText;
        } else if (
          link.children &&
          link.children.length &&
          link.children[0].innerText
        ) {
          newLink.innerText = link.children[0].innerText;
        } else {
          newLink.innerText = currentHref;
        }

        if (link.parentNode.tagName === "P") {
          link.parentNode.replaceChild(newLink, link);
        } else {
          newLink.innerText = "";
          console.log(currentHref);
          link.parentNode.replaceChild(newLink, link);
        }
      }
    });
  }

  prependChromepickerToLinks(document.querySelectorAll('a[target="_blank"]'));

  const observer = new MutationObserver((mutationsList) => {
    for (const mutation of mutationsList) {
      if (mutation.type === "childList") {
        mutation.addedNodes.forEach((node) => {
          if (node.tagName === "A") {
            prependChromepickerToLinks([node]);
          } else if (node.querySelectorAll) {
            prependChromepickerToLinks(node.querySelectorAll("a"));
          }
        });
      }
    }
  });

  // Start observing the document body for added nodes
  observer.observe(document.body, { childList: true, subtree: true });
})();
