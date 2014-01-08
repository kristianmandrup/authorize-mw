rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_             = require 'prelude-ls'
lo            = require 'lodash'
User          = requires.fix 'user'
Book          = requires.fix 'book'

request       = requires.fix 'request'
users         = requires.fix 'users'
permits       = requires.fix 'permits'

ability       = require './ability/abilities'

Allower       = requires.file 'allower'
Ability       = requires.file 'ability'
Permit        = requires.file 'permit'
permit-for    = requires.file 'permit_for'
PermitMatcher = requires.file 'permit_matcher'

describe 'Ability' ->
  var abook

  book = (title) ->
    new Book title: title

  describe 'create' ->
    context 'Ability for kris' ->
      specify 'is an Ability' ->
        ability.kris.constructor.should.eql Ability

      describe 'user' ->
        specify 'has user kris' ->
          ability.kris.user.should.eql users.kris

  describe 'allower' ->
    specify 'return Allower instance' ->
      ability.kris.allower(access.empty).constructor.should.eql Allower

    specify 'Allower sets own access-request obj' ->
      ability.kris.allower(access.user).access-request.should.eql access.user

  describe 'allowed-for' ->
    context 'guest ability' ->
      xspecify 'read a book access should be allowed for admin user' ->
        ability.guest.allowed-for(action: 'read', subject: book).should.be.true

      specify 'write a book access should NOT be allowed for guest user' ->
        ability.guest.allowed-for(action: 'write', subject: book).should.be.false

    context 'admin ability' ->
      xspecify 'write a book access should be allowed for admin user' ->
        admin-ability.allowed-for(action: 'write', subject: book).should.be.true

  xdescribe 'not-allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      ability.guest.not-allowed-for(action: 'read', subject: book).should.be.false

    xspecify 'write a book access should NOT be allowed for guest user' ->
      ability.guest.not-allowed-for(action: 'write', subject: book).should.be.true

    xspecify 'write a book access should be allowed for admin user' ->
      ability.admin.not-allowed-for(action: 'write', subject: book).should.be.false
