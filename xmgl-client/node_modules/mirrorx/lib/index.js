'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.withRouter = exports.Prompt = exports.Redirect = exports.Switch = exports.NavLink = exports.Link = exports.Route = exports.Router = exports.render = exports.connect = exports.defaults = exports.hook = exports.actions = exports.model = undefined;

var _reactRouter = require('react-router');

var _reactRouterDom = require('react-router-dom');

var _reactRedux = require('react-redux');

var _model = require('./model');

var _model2 = _interopRequireDefault(_model);

var _actions = require('./actions');

var _render = require('./render');

var _render2 = _interopRequireDefault(_render);

var _hook = require('./hook');

var _hook2 = _interopRequireDefault(_hook);

var _router = require('./router');

var _router2 = _interopRequireDefault(_router);

var _defaults = require('./defaults');

var _defaults2 = _interopRequireDefault(_defaults);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
  model: _model2.default,
  actions: _actions.actions,
  hook: _hook2.default,
  defaults: _defaults2.default,
  connect: _reactRedux.connect,
  render: _render2.default,

  Router: _router2.default,
  Route: _reactRouter.Route,
  Link: _reactRouterDom.Link,
  NavLink: _reactRouterDom.NavLink,
  Switch: _reactRouter.Switch,
  Redirect: _reactRouter.Redirect,
  Prompt: _reactRouter.Prompt,
  withRouter: _reactRouter.withRouter
};
exports.model = _model2.default;
exports.actions = _actions.actions;
exports.hook = _hook2.default;
exports.defaults = _defaults2.default;
exports.connect = _reactRedux.connect;
exports.render = _render2.default;
exports.Router = _router2.default;
exports.Route = _reactRouter.Route;
exports.Link = _reactRouterDom.Link;
exports.NavLink = _reactRouterDom.NavLink;
exports.Switch = _reactRouter.Switch;
exports.Redirect = _reactRouter.Redirect;
exports.Prompt = _reactRouter.Prompt;
exports.withRouter = _reactRouter.withRouter;