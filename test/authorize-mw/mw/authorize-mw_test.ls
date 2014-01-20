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

Authorizer      = requires.file 'mw/authorize-mw'

Ability         = requires.file 'ability'

describe 'AuthorizeMw' ->
  var ctx

  users           = {}
  requests        = {}
  permits         = {}
  authorizations  = {}

  authorization = (context) ->
    new Authorization context

  before ->
    book              = new Book title: 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    requests.read-book =
      name:       'read'
      collection: 'books'

    ctx :=
      current-user: users.guest

    authorizations.basic = authorization context

  describe 'create' ->
    specify 'should set context' ->
      authorizations.basic.context.should.eql ctx

    specify 'should set current-user' ->
      authorizations.basic.current-user.should.eql ctx.current-user

    describe 'ability' ->
      specify 'should set ability' ->
        authorizations.basic.ability!.constructor.should.eql Ability

      specify 'should set ability user to current user' ->
        authorizations.basic.ability!.user.constructor.should.eql ctx.current-user

  xdescribe 'run' ->
    context 'read book request by guest user' ->
      before ->

      specify 'user is authorized to perform action' ->
        authorizations.basic.run(requests.read-book).should.be.true