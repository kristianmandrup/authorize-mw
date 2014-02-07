rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_               = require 'prelude-ls'
lo              = require 'lodash'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'

AuthorizeMw     = requires.afile 'mw/authorize-mw'
Authorizer      = requires.file 'authorizer'

describe 'AuthorizeMw' ->
  var ctx

  users           = {}
  requests        = {}
  permits         = {}
  authorize-mws   = {}

  authorize-mw = (context) ->
    new AuthorizeMw context

  before ->
    book              = new Book title: 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    ctx :=
      current-user: users.guest

    authorize-mws.basic = authorize-mw ctx

  describe 'create' ->
    specify 'should set context' ->
      authorize-mws.basic.context.should.eql ctx

    specify 'should set current-user' ->
      authorize-mws.basic.current-user.should.eql ctx.current-user

  describe 'authorizer' ->
    specify 'should set authorizer' ->
      authorize-mws.basic.authorizer!.constructor.should.eql Authorizer

    specify 'should set authorizer user to current user' ->
      authorize-mws.basic.authorizer!.user.should.eql ctx.current-user

  describe 'run' ->
    context 'read book request by guest user' ->
      before ->
        requests.read-book =
          action      :   'read'
          collection  :   'books'

        authorize-mws.basic.clear!
        # authorize-mws.basic.debug-on!

      specify 'user is authorized to read book' ->
        authorize-mws.basic.run-alone(requests.read-book).should.be.true

  describe 'run' ->
    context 'read book request by guest user' ->
      before ->
        requests.create-book =
          action      :   'create'
          collection  :   'books'

        authorize-mws.basic.clear!
        # authorize-mws.basic.debug-on!

      specify 'user is NOT authorized to create a new book' ->
        authorize-mws.basic.run-alone(requests.create-book).should.be.false


  describe 'run' ->
    context 'edit user request by guest user' ->
      before ->
        requests.edit-user =
          action  :       'edit'
          data    :       users.guest

        requests.create-user =
          action  :       'create'
          data    :       users.guest

        permits.admin     = create-permit.matching.role.admin! # check rules!

        users.admin       = create-user.admin!

        ctx :=
          current-user: users.admin

        authorize-mws.user = authorize-mw ctx

      specify 'admin user is authorized to edit another user' ->
        authorize-mws.user.run-alone(requests.edit-user).should.be.true

      specify 'admin user is NOT authorized to create another user' ->
        authorize-mws.user.run-alone(requests.create-user).should.be.false