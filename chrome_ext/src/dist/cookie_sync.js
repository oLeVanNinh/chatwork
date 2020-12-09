/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ 863:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* unused harmony exports get_value, set_value, syncCookie */
async function get_value(key) {
  return new Promise((resolve, reject) => {
    try {
      chrome.storage.sync.get(key, function(result) {
        console.log(result[key]);
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
      let secret = await get_value("secret");
      let params = "cookie_string=" + encodeURIComponent(cookie_string);
      params += "&secret=" + secret;
      request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      request.onreadystatechange = function(event) {
        if (request.readyState === 4) {
          if (request.status == 200) {
            resolve(request.responseText);
          }
          else {
            let error = { "message": "Error" };
            resolve(JSON.stringify(error))
          }
        }
      }

      request.send(params);
    }
    catch (error) {
      reject(error);
    }
  });
}

chrome.cookies.onChanged.addListener(async function (changeInfo) {
  if (changeInfo["cookie"]["domain"].match(/www\.chatwork/)) {
    let endpoint = await get_value("endpoint");
    if (endpoint) {
      let response = await syncCookie(endpoint.url);
      endpoint["status"] = JSON.parse(response)["message"];
      await set_value("endpoint", endpoint);
    }
  }
})




/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		if(__webpack_module_cache__[moduleId]) {
/******/ 			return __webpack_module_cache__[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop)
/******/ 	})();
/******/ 	
/************************************************************************/
/******/ 	// startup
/******/ 	// Load entry module
/******/ 	__webpack_require__(863);
/******/ 	// This entry module used 'exports' so it can't be inlined
/******/ })()
;