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

Authorizer      = requires.file 'authorizer'

Ability         = requires.file 'ability'

describe 'Authorizer' ->
  var ctx

  users         = {}
  requests      = {}
  permits       = {}
  authorizers   = {}

  authorizer = (user) ->
    new Authorizer user

  before ->
    book              = new Book title: 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    requests.read-book =
      name:       'read'
      collection: 'books'

    ctx :=
      current-user: users.guest

    authorizers.basic = authorizer users.guest

  describe 'create' ->
    specify 'should set user' ->
      authorizers.basic.user.should.eql users.guest

  xdescribe 'run' ->
    context 'read book request by guest user' ->
      before ->

      specify 'user is authorized to perform action' ->
        authorizers.basic.run(requests.read-book).should.be.true