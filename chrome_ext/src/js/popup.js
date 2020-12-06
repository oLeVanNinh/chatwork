// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

'use strict';

import { syncCookie, set_value, get_value } from './cookie_sync.js'

var $ = require('jquery');
window.jQuery = $;
window.$ = $;


window.onload = async function() {
  // Must type secret before input url
  let secret = await get_value("secret");
  if (!secret) {
    $("#url").hide();
  }
  else {
    set_display_secret();
  }

  $("#add-secret").click(async function() {
    let is_edit = $("#secret input").prop("readonly");

    if (is_edit) {
      $("#secret input").prop("readonly", false);
      $("#add-secret").text("Save");
    }
    else {
      secret = $("#secret input").val().trim();
      if (secret) {
        await set_value("secret", secret);
        set_display_secret();
      }
    }
  });
}

function set_display_secret() {
  get_value("secret").then((secret) => {
    $("#secret input").val(secret)
  })
  $("#secret input").prop("readonly", true);
  $("#add-secret").text("Edit");
}


init_load_endpoint()

let submitButton = document.getElementById('add_url');

// Store server url and then send cookie to that server

submitButton.onclick = async function() {
  let urlInput = document.getElementById("sync_url");
  let url = urlInput.value.trim();

  if (url) {
    let response = await syncCookie(url);
    urlInput.value = "";
    let endpoint = { url: url, status: JSON.parse(response)["message"] };
    await set_value("endpoint", endpoint);
    updateListEndpoint(endpoint);
  }
}

async function init_load_endpoint() {
  let endpoint = await get_value("endpoint")
  updateListEndpoint(endpoint);
}

function updateListEndpoint(endpoint) {
  if (endpoint) {
    console.log(endpoint);
    let element_string = `<div>${endpoint.url}</div><div class="text-info">${endpoint.status}</div`
    let node = document.getElementById('url-list');
    node.innerHTML = element_string;
  }
}
