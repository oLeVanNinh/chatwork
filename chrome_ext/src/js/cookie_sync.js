async function get_value(key) {
  return new Promise((resolve, reject) => {
    try {
      chrome.storage.sync.get(key, function(result) {
        resolve(result[key])
      })
    }
    catch(error) {
      reject(error)
    }
  })
}

async function set_value(key, value) {
  return new Promise((resolve, reject) => {
    let data = {};
    data[key] = value;
    try {
      chrome.storage.sync.set(data , function() {
        resolve(key);
      })
    }
    catch (error) {
      reject(error);
    }
  })
}

async function buildCookieString() {
  return new Promise((resolve, reject) => {
    try {
      chrome.cookies.getAll({domain: ".chatwork.com"}, function(cookies) {
        let cookie_string = cookies.map((cookie) => (
          [cookie.name, cookie.value].join("=")
        )).join("; ");
        resolve(cookie_string);
      });
    }
    catch(error) {
      reject(error);
    }
  });
}

function syncCookie(url) {
  return new Promise(async (resolve, reject) => {
    try {
      let request = new XMLHttpRequest();
      request.open("POST", url, true);
      let cookie_string = await buildCookieString();
      let params = "cookie_string=" + encodeURIComponent(cookie_string);
      request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      request.onload = function() {
        let response = this.responseText;
        resolve(response)
      }

      request.send(params);
    }
    catch (error) {
      reject(error);
    }
  });
}

chrome.cookies.onChanged.addListener(async function (changeInfo) {
  if (changeInfo["cookie"]["domain"].match(/chatwork/)) {
    let endpoint = await get_value("endpoint");
    if (endpoint) {
      let response = await syncCookie(endpoint.url);
      endpoint["status"] = JSON.parse(response)["message"];
      await set_value("endpoint", endpoint);
    }
  }
})

export { get_value, set_value, syncCookie }