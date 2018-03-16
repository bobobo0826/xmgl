'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getState = exports.dispatch = undefined;
exports.default = createMiddleware;

var _effects = require('./effects');

var _hook = require('./hook');

function warning() {
  throw new Error('You are calling "dispatch" or "getState" without applying mirrorMiddleware! ' + 'Please create your store with mirrorMiddleware first!');
}

var dispatch = exports.dispatch = warning;

var getState = exports.getState = warning;

function createMiddleware() {
  return function (middlewareAPI) {
    exports.dispatch = dispatch = middlewareAPI.dispatch;
    exports.getState = getState = middlewareAPI.getState;

    return function (next) {
      return function (action) {

        var result = next(action);

        if (typeof _effects.effects[action.type] === 'function') {
          result = _effects.effects[action.type](action.data, getState);
        }

        _hook.hooks.forEach(function (hook) {
          return hook(action, getState);
        });

        return result;
      };
    };
  };
}