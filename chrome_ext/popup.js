// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

'use strict';

// let changeColor = document.getElementById('changeColor');

// chrome.storage.sync.get('color', function(data) {
//   changeColor.style.backgroundColor = data.color;
//   changeColor.setAttribute('value', data.color);
// });

// changeColor.onclick = function(element) {
//   let color = element.target.value;
//   chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
//     chrome.tabs.executeScript(
//         tabs[0].id,
//         {code: 'document.body.style.backgroundColor = "' + color + '";'});
//   });

//   chrome.cookies.getAll({domain: ".chatwork.com"}, function(cookies) {
//     var str = {}
//     for (var i of cookies) {
//       str[i.name] = i.value
//     }
//     console.log(str)
//   });
// };

let submitButton = document.getElementById('add_url');
submitButton.onclick = function() {
  let urlInput = document.getElementById("sync_url");
  let url = urlInput.value.trim();
  if (url) {
    let endpoint = { url: url, status: false }
    chrome.storage.sync.set({ endpoint:  endpoint}, function() {
      urlInput.value = "";
      updateListEndpoint(endpoint)
    })
  }
}

chrome.storage.sync.get(["endpoint"], function(result) {
  let endpoint = result['endpoint']
  updateListEndpoint(endpoint);
});

function updateListEndpoint(endpoint) {
  if (endpoint) {
    let element_string = `<div>${endpoint.url}</div><div>${endpoint.status}</div`
    let node = document.getElementById('url-list');
    node.innerHTML = element_string;
  }
}
