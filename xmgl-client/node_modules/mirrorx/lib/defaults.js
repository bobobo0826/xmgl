'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.options = undefined;
exports.default = defaults;

var _effects = require('./effects');

var options = exports.options = {
  historyMode: 'browser',

  middlewares: [],

  reducers: {},

  addEffect: (0, _effects.addEffect)(_effects.effects)

};

var historyModes = ['browser', 'hash', 'memory'];

function defaults() {
  var opts = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var historyMode = opts.historyMode,
      middlewares = opts.middlewares,
      addEffect = opts.addEffect;


  if (historyMode && !historyModes.includes(historyMode)) {
    throw new Error('historyMode "' + historyMode + '" is invalid, must be one of ' + historyModes.join(', ') + '!');
  }

  if (middlewares && !Array.isArray(middlewares)) {
    throw new Error('middlewares "' + middlewares + '" is invalid, must be an Array!');
  }

  if (addEffect) {
    if (typeof addEffect !== 'function' || typeof addEffect({}) !== 'function') {
      throw new Error('addEffect "' + addEffect + '" is invalid, must be a function that returns a function');
    } else {
      opts.addEffect = opts.addEffect(_effects.effects);
    }
  }

  Object.keys(opts).forEach(function (key) {
    options[key] = opts[key];
  });
}