// Generated by LiveScript 1.2.0
(function(){
  var requires, _, lo, assert, expect, User, Book, createRequest, createUser, createPermit, AuthorizeMw, Authorizer, middleware, Middleware;
  requires = require('../../../requires');
  requires.test('test_setup');
  _ = require('prelude-ls');
  lo = require('lodash');
  assert = require('chai').assert;
  expect = require('chai').expect;
  User = requires.fix('user');
  Book = requires.fix('book');
  createRequest = requires.fac('create-request');
  createUser = requires.fac('create-user');
  createPermit = requires.fac('create-permit');
  AuthorizeMw = requires.mw('authorize-mw');
  Authorizer = requires.lib('authorizer');
  middleware = require('middleware');
  Middleware = middleware.Middleware;
  describe('Model MiddleWare using AuthorizeMw', function(){
    var ctx, users, books, requests, permits, authorizeMws, middlewares, authorizeMw, modelMiddleware, book;
    users = {};
    books = {};
    requests = {};
    permits = {};
    authorizeMws = {};
    middlewares = {};
    authorizeMw = function(context){
      return new AuthorizeMw(context);
    };
    modelMiddleware = function(ctx){
      return new Middleware('model', ctx);
    };
    book = function(title){
      return new Book({
        title: title
      });
    };
    before(function(){
      books.hello = book('hello');
      users.guest = createUser.guest();
      permits.guest = createPermit.matching.role.guest();
      ctx = {
        currentUser: users.guest
      };
      authorizeMws.basic = authorizeMw(ctx);
      middlewares.auth = modelMiddleware({
        data: books.hello
      });
      return middlewares.auth.use({
        authorize: authorizeMws.basic
      });
    });
    describe('run', function(){
      return context('read book request by guest user', function(){
        var res;
        before(function(){
          requests.readBook = {
            action: 'read',
            collection: 'books'
          };
          return res = middlewares.auth.run(requests.readBook);
        });
        return context('result', function(){
          specify('is success', function(){
            return expect(res.success).to.be['true'];
          });
          specify('no errors', function(){
            return expect(res.errors).to.be.empty;
          });
          return specify('authorized', function(){
            return expect(res.results.authorize).to.be['true'];
          });
        });
      });
    });
    return describe('run', function(){
      context('create book request by guest user', function(){
        var res;
        before(function(){
          requests.createBook = {
            action: 'create',
            collection: 'books'
          };
          return res = middlewares.auth.run(requests.createBook);
        });
        return specify('user is NOT authorized to create a new book', function(){
          return expect(res.results.authorize).to.be['false'];
        });
      });
      return describe('read user request by guest user', function(){
        var res;
        before(function(){
          requests.readUser = {
            action: 'read',
            collection: 'users'
          };
          authorizeMws.smart = authorizeMw(ctx);
          middlewares.smart = modelMiddleware({
            data: books.hello
          });
          middlewares.smart.use({
            authorize: authorizeMws.smart
          });
          return res = middlewares.smart.run(requests.readUser);
        });
        context('mw data context', function(){
          specify('model changed to user', function(){
            return expect(authorizeMws.smart.model).to.eql('user');
          });
          specify('collection still users', function(){
            return expect(authorizeMws.smart.collection).to.eql('users');
          });
          return specify('data set to void', function(){
            return expect(authorizeMws.smart.data).to.eql(void 8);
          });
        });
        context('result', function(){
          specify('is success', function(){
            return expect(res.success).to.be['true'];
          });
          specify('no errors', function(){
            return expect(res.errors).to.be.empty;
          });
          return specify('authorized since data and model were changed', function(){
            return expect(res.results.authorize).to.be['false'];
          });
        });
        return describe('middlewares.auth', function(){
          var mergedCtx;
          before(function(){
            return mergedCtx = authorizeMws.smart.smartMerge({
              action: 'read',
              collection: 'users'
            });
          });
          specify('data is void', function(){
            return expect(mergedCtx.data).to.eql(void 8);
          });
          specify('collection is users', function(){
            return expect(mergedCtx.collection).to.eql('users');
          });
          specify('action is read', function(){
            return expect(mergedCtx.action).to.eql('read');
          });
          return specify('model is user', function(){
            return expect(mergedCtx.model).to.eql(void 8);
          });
        });
      });
    });
  });
}).call(this);
