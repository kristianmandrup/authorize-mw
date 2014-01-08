rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

request       = requires.fix 'request'
users         = requires.fix 'users'

permits       = require './permits'
access        = require './access'
ability       = require './abilities'

Ability       = requires.file 'ability'

describe 'Ability' ->
  book = (title) ->
    new Book title: title

  describe 'access-obj' ->
    context 'Ability for kris' ->
      specify 'extends empty access with user thas has a name' ->
        ability.kris.access-obj(empty-access).user.should.have.property 'name'

      specify 'extends empty access with user' ->
        ability.kris.access-obj(empty-access).user.name.should.eql 'kris'

      specify 'extends access with user.role' ->
        ability.kris.access-obj(guest-access).user.should.have.property 'role'

    context 'Guest ability' ->
      var read-book-access, abook

      before ->
        abook := book 'far and away'

        read-book-access :=
          action: 'read'
          subject: abook

      describe 'access-obj' ->
        context 'access-obj extended with read-book-access' ->
          var res
          before-each ->
            res := ability.guest.access-obj(read-book-access)

        specify 'adds user.role: guest' ->
          res.user.role.should.eql 'guest'

        specify 'adds action: read' ->
          res.action.should.eql 'read'

        specify 'adds subject: book' ->
          res.subject.should.eql abook