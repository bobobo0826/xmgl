'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = routerMiddleware;

var _reactRouterRedux = require('react-router-redux');

var _router = require('./router');

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function routerMiddleware() {
  return function () {
    return function (next) {
      return function (action) {
        if (action.type !== _reactRouterRedux.CALL_HISTORY_METHOD) {
          return next(action);
        }

        var _action$payload = action.payload,
            method = _action$payload.method,
            args = _action$payload.args;

        _router.history[method].apply(_router.history, _toConsumableArray(args));
      };
    };
  };
}