/******/ (function() { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "../../../../.rbenv/versions/2.7.3/lib/ruby/gems/2.7.0/gems/decidim-direct_verifications-1.2.1/app/packs/src/decidim/direct_verifications/admin/participants.js":
/*!**********************************************************************************************************************************************************************!*\
  !*** ../../../../.rbenv/versions/2.7.3/lib/ruby/gems/2.7.0/gems/decidim-direct_verifications-1.2.1/app/packs/src/decidim/direct_verifications/admin/participants.js ***!
  \**********************************************************************************************************************************************************************/
/***/ (function() {

function _typeof(o) {
  "@babel/helpers - typeof";

  return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) {
    return typeof o;
  } : function (o) {
    return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o;
  }, _typeof(o);
}
function _classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
}
function _defineProperties(target, props) {
  for (var i = 0; i < props.length; i++) {
    var descriptor = props[i];
    descriptor.enumerable = descriptor.enumerable || false;
    descriptor.configurable = true;
    if ("value" in descriptor) descriptor.writable = true;
    Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor);
  }
}
function _createClass(Constructor, protoProps, staticProps) {
  if (protoProps) _defineProperties(Constructor.prototype, protoProps);
  if (staticProps) _defineProperties(Constructor, staticProps);
  Object.defineProperty(Constructor, "prototype", {
    writable: false
  });
  return Constructor;
}
function _toPropertyKey(t) {
  var i = _toPrimitive(t, "string");
  return "symbol" == _typeof(i) ? i : String(i);
}
function _toPrimitive(t, r) {
  if ("object" != _typeof(t) || !t) return t;
  var e = t[Symbol.toPrimitive];
  if (void 0 !== e) {
    var i = e.call(t, r || "default");
    if ("object" != _typeof(i)) return i;
    throw new TypeError("@@toPrimitive must return a primitive value.");
  }
  return ("string" === r ? String : Number)(t);
}
var VerificationUI = /*#__PURE__*/function () {
  function VerificationUI($table, config) {
    var _this = this;
    _classCallCheck(this, VerificationUI);
    this.$table = $table;
    this.svgPath = $table.find("use[href]:first").attr("href").split("#")[0];
    this.icon = "icon-key";
    this.config = config;
    this.$table.on("click", ".show-verifications-modal", function (e) {
      return _this.toggleModal(e);
    });
    this.addModal();
  }
  _createClass(VerificationUI, [{
    key: "addModal",
    value: function addModal() {
      this.$modal = $("<div class=\"reveal\" id=\"show-verifications-modal\" data-reveal>\n  <div class=\"reveal__header\">\n    <h3 class=\"reveal__title\">".concat(this.config.modalTitle, "</h3>\n    <button class=\"close-button\" data-close aria-label=\"").concat(this.config.closeModalLabel, "\"\n      type=\"button\">\n      <span aria-hidden=\"true\">&times;</span>\n    </button>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"columns medium-4 medium-centered modal-body\">\n    </div>\n  </div>\n</div>"));
      this.$table.after(this.$modal);
      this.$title = $("#user-groups .card-title:first");
      this.$modalBody = this.$modal.find(".modal-body");
      this.reveal = new Foundation.Reveal(this.$modal);
    }
  }, {
    key: "drawButtons",
    value: function drawButtons() {
      var _this2 = this;
      this.$table.find("tbody tr").each(function (idx, tr) {
        var $lastTd = $(tr).find("td:last");
        $lastTd.prepend("<a class=\"action-icon action-icon action-icon show-verifications-modal\" title=\"".concat(_this2.config.buttonTitle, "\" href=\"#open-show-verifications-modal\"><span class=\"has-tip ").concat(_this2.getTrStatus(tr), "\"><svg aria-label=\"").concat(_this2.config.buttonTitle, "\" role=\"img\" class=\"icon--ban icon\">\n        <title>").concat(_this2.config.buttonTitle, "</title>\n        <use href=\"").concat(_this2.svgPath, "#").concat(_this2.icon, "\"></use>\n        </svg></span></a>"));
      });
    }
  }, {
    key: "addStatsTitle",
    value: function addStatsTitle() {
      var _this3 = this;
      // Add upper link to verification stats
      var $a = $("<a class=\"button tiny button--title\" href=\"".concat(this.config.statsPath, "\">").concat(this.config.statsLabel, "</a>"));
      $a.on("click", function (e) {
        e.preventDefault();
        _this3.loadUrl($a.attr("href"), true);
      });
      this.$title.append($a);
    }
  }, {
    key: "getTrStatus",
    value: function getTrStatus(tr) {
      return this.getUserVerifications($(tr).data("user-id")).length ? "alert" : "";
    }
  }, {
    key: "getVerification",
    value: function getVerification(id) {
      return this.config.verifications.find(function (auth) {
        return auth.id == id;
      });
    }
  }, {
    key: "getUserVerifications",
    value: function getUserVerifications(userId) {
      return this.config.verifications.filter(function (auth) {
        return auth.userId == userId;
      });
    }
  }, {
    key: "toggleModal",
    value: function toggleModal(e) {
      var userId = $(e.target).closest("tr").data("user-id");
      this.loadUrl(this.config.userVerificationsPath.replace("-ID-", userId));
    }
  }, {
    key: "loadUrl",
    value: function loadUrl(url) {
      var large = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
      this.$modal.removeClass("large");
      if (large) {
        this.$modal.addClass("large");
      }
      this.$modalBody.html('<span class="loading-spinner"></span>');
      this.$modalBody.load(url);
      this.$modal.foundation("toggle");
    }
  }]);
  return VerificationUI;
}();
$(function () {
  var ui = new VerificationUI($("#user-groups table.table-list"), DirectVerificationsConfig);
  // Draw the icon buttons for checking verification statuses
  ui.drawButtons();
  ui.addStatsTitle();
});

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
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
/******/ 	/* webpack/runtime/compat get default export */
/******/ 	!function() {
/******/ 		// getDefaultExport function for compatibility with non-harmony modules
/******/ 		__webpack_require__.n = function(module) {
/******/ 			var getter = module && module.__esModule ?
/******/ 				function() { return module['default']; } :
/******/ 				function() { return module; };
/******/ 			__webpack_require__.d(getter, { a: getter });
/******/ 			return getter;
/******/ 		};
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/define property getters */
/******/ 	!function() {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = function(exports, definition) {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	!function() {
/******/ 		__webpack_require__.o = function(obj, prop) { return Object.prototype.hasOwnProperty.call(obj, prop); }
/******/ 	}();
/******/ 	
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	!function() {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = function(exports) {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	}();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be in strict mode.
!function() {
"use strict";
/*!************************************************************************************************************************************************************************!*\
  !*** ../../../../.rbenv/versions/2.7.3/lib/ruby/gems/2.7.0/gems/decidim-direct_verifications-1.2.1/app/packs/entrypoints/decidim_direct_verifications_participants.js ***!
  \************************************************************************************************************************************************************************/
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var src_decidim_direct_verifications_admin_participants_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! src/decidim/direct_verifications/admin/participants.js */ "../../../../.rbenv/versions/2.7.3/lib/ruby/gems/2.7.0/gems/decidim-direct_verifications-1.2.1/app/packs/src/decidim/direct_verifications/admin/participants.js");
/* harmony import */ var src_decidim_direct_verifications_admin_participants_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(src_decidim_direct_verifications_admin_participants_js__WEBPACK_IMPORTED_MODULE_0__);

}();
/******/ })()
;
//# sourceMappingURL=decidim_direct_verifications_participants.js.map