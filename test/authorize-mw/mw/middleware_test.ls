requires        = require '../../../requires'

requires.test 'test_setup'

_               = require 'prelude-ls'
lo              = require 'lodash'

assert = require('chai').assert
expect = require('chai').expect

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'

AuthorizeMw     = requires.mw  'authorize-mw'
Authorizer      = requires.lib 'authorizer'

middleware      = require 'middleware'
Middleware      = middleware.Middleware

describe 'Model MiddleWare using AuthorizeMw' ->
  var ctx

  users           = {}
  books           = {}
  requests        = {}
  permits         = {}
  authorize-mws   = {}
  middlewares     = {}

  authorize-mw = (context) ->
    new AuthorizeMw context

  model-middleware = (ctx) ->
    new Middleware 'model', ctx

  book = (title) ->
    new Book title: title

  before ->
    books.hello       = book 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    ctx :=
      current-user: users.guest

    authorize-mws.basic = authorize-mw ctx
    middlewares.auth    = model-middleware data: books.hello
    middlewares.auth.use authorize: authorize-mws.basic

  describe 'run' ->
    context 'read book request by guest user' ->
      var res

      before ->
        requests.read-book =
          action      :   'read'
          collection  :   'books'

        res := middlewares.auth.run requests.read-book

      context 'result' ->
        specify 'is success' ->
          expect(res.success).to.be.true

        specify 'no errors' ->
          expect(res.errors).to.be.empty

        specify 'authorized' ->
          expect(res.results.authorize)to.be.true

  describe 'run' ->
    context 'create book request by guest user' ->
      var res

      before ->
        requests.create-book =
          action      :   'create'
          collection  :   'books'

        res := middlewares.auth.run requests.create-book

      specify 'user is NOT authorized to create a new book' ->
        expect(res.results.authorize)to.be.false

    describe 'read user request by guest user' ->
      var res

      before ->
        requests.read-user =
          action      :   'read'
          collection  :   'users'

        authorize-mws.smart = authorize-mw ctx
        middlewares.smart    = model-middleware data: books.hello
        middlewares.smart.use authorize: authorize-mws.smart

        res := middlewares.smart.run requests.read-user

      context 'mw data context' ->
        specify 'model changed to user' ->
          expect(authorize-mws.smart.model).to.eql 'user'

        specify 'collection still users' ->
          expect(authorize-mws.smart.collection).to.eql 'users'

        specify 'data set to void' ->
          expect(authorize-mws.smart.data).to.eql void

      context 'result' ->
        specify 'is success' ->
          expect(res.success).to.be.true

        specify 'no errors' ->
          expect(res.errors).to.be.empty

        specify 'authorized since data and model were changed' ->
          expect(res.results.authorize)to.be.false

      describe 'middlewares.auth' ->
        var merged-ctx
        before ->
          merged-ctx := authorize-mws.smart.smart-merge action: 'read', collection: 'users'

        specify 'data is void' ->
          expect(merged-ctx.data).to.eql void

        specify 'collection is users' ->
          expect(merged-ctx.collection).to.eql 'users'

        specify 'action is read' ->
          expect(merged-ctx.action).to.eql 'read'

        specify 'model is user' ->
          expect(merged-ctx.model).to.eql void
