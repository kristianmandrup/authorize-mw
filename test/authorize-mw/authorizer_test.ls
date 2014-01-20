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
  books         = {}

  book = (title) ->
    new Book title: title

  authorizer = (user) ->
    new Authorizer user

  before ->
    books.hello       = book 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    ctx :=
      current-user: users.guest

    authorizers.basic = authorizer users.guest

  describe 'create' ->
    specify 'should set user' ->
      authorizers.basic.user.should.eql users.guest

  describe 'run' ->
    context 'read book (collection name) request by guest user' ->
      before ->
        requests.read-book-collection =
          name:       'read'
          collection: 'books'

      specify 'user is authorized to perform action' ->
        authorizers.basic.run(requests.read-book-collectionst).should.be.true


  describe 'run' ->
    context 'read actual book instance request by guest user' ->
      before ->
        requests.read-book =
          name: 'read'
          data: book

      specify 'user is authorized to perform action' ->
        authorizers.basic.run(requests.read-book).should.be.true

  describe 'run' ->
    context 'read actual book model request by guest user' ->
      before ->
        requests.read-book-model =
          name: 'read'
          model: book

      specify 'user is authorized to perform action' ->
        authorizers.basic.run(requests.read-book-model).should.be.true