// ==UserScript==
// @name         ChromePicker Teams
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
        newLink.setAttribute(
          "href",
          "chromepicker:" + currentHref + "@teamslectra",
        );
        const isMeeting = !!document.querySelector(
          'button[data-inp="microphone-button"]',
        );
        if (isMeeting) {
          newLink.setAttribute("target", "_blank");
        }
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

  // Handle Attachment files
  const attachedIds = {};

  function handleAttachmentClick(event) {
    var isContextButton = !!event.target.closest(".ui-button");
    if (isContextButton) {
      return;
    }

    var isCopyLinkButton = !!event.target.closest(".fui-Button");
    if (isCopyLinkButton) {
      return;
    }

    event.stopPropagation();
    event.preventDefault();
    event.stopImmediatePropagation();

    var element = event.target.closest('[data-tid="file-attachment-grid"]');

    if (element && element.children.length > 0) {
      var firstChild = element.children[0];
      if (firstChild.title) {
        var title = firstChild.title;
        var urlStartIndex = title.indexOf("https");
        if (urlStartIndex !== -1) {
          var url = title.substring(urlStartIndex);
          if (url.includes(" ")) {
            url = encodeURI(url);
          }
          console.log("Extracted URL:", url);
          var link = document.createElement("a");
          link.setAttribute("href", "chromepicker:" + url + "@teamslectra");
          console.log("chromepicker:" + url + "@teamslectra");
          link.click();
        }
      }
    }
  }

  function attachAttachmentClickListener(element) {
    let elementId = element.getAttribute("id");

    if (!elementId.startsWith("attachments")) {
      return;
    }
    if (attachedIds[elementId]) {
      element.removeEventListener("click", handleAttachmentClick);
    }

    attachedIds[elementId] = 1;
    element.addEventListener("click", handleAttachmentClick);
  }

  document
    .querySelectorAll('[data-tid="file-attachment-grid"]')
    .forEach(attachAttachmentClickListener);
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

    for (const mutation of mutationsList) {
      if (mutation.type === "childList") {
        mutation.addedNodes.forEach((node) => {
          if (node.tagName === "DIV") {
            var dataId = node.getAttribute("data-tid");
            if (dataId && dataId.startsWith("file-chiclet")) {
              document
                .querySelectorAll('[data-tid="file-attachment-grid"]')
                .forEach(attachAttachmentClickListener);
              return;
            }
          }
        });
      }
      var node = mutation.target;
      if (
        node.tagName === "DIV" &&
        node.getAttribute("data-tid") == "channel-pane-runway"
      ) {
        document
          .querySelectorAll('[data-tid="file-attachment-grid"]')
          .forEach(attachAttachmentClickListener);
        return;
      }
    }
  });

  // Start observing the document body for added nodes
  observer.observe(document.body, { childList: true, subtree: true });
})();
