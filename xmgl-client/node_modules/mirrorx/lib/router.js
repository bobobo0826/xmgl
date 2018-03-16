'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.history = undefined;
exports.default = Router;

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _createBrowserHistory = require('history/createBrowserHistory');

var _createBrowserHistory2 = _interopRequireDefault(_createBrowserHistory);

var _createHashHistory = require('history/createHashHistory');

var _createHashHistory2 = _interopRequireDefault(_createHashHistory);

var _createMemoryHistory = require('history/createMemoryHistory');

var _createMemoryHistory2 = _interopRequireDefault(_createMemoryHistory);

var _reactRouterRedux = require('react-router-redux');

var _defaults = require('./defaults');

var _middleware = require('./middleware');

var _actions = require('./actions');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }

var history = exports.history = null;

function Router(_ref) {
  var _history = _ref.history,
      children = _ref.children,
      others = _objectWithoutProperties(_ref, ['history', 'children']);

  _actions.actions.routing = Object.keys(_reactRouterRedux.routerActions).reduce(function (memo, action) {
    memo[action] = function () {
      (0, _middleware.dispatch)(_reactRouterRedux.routerActions[action].apply(_reactRouterRedux.routerActions, arguments));
    };
    return memo;
  }, {});

  if (!_history) {
    _history = createHistory(others);
  }

  exports.history = history = _history;

  return _react2.default.createElement(
    _reactRouterRedux.ConnectedRouter,
    { history: _history },
    children
  );
}

Router.propTypes = {
  children: _propTypes2.default.element.isRequired,
  history: _propTypes2.default.object
};

function createHistory(props) {
  var historyMode = _defaults.options.historyMode;


  var historyModes = {
    browser: _createBrowserHistory2.default,
    hash: _createHashHistory2.default,
    memory: _createMemoryHistory2.default
  };

  exports.history = history = historyModes[historyMode](props);

  return history;
}