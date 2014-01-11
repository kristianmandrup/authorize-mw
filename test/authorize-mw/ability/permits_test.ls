rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'

permits         = require './permits'
access          = require './access'
ability         = require './abilities'

Ability         = requires.file 'ability'
Permit          = requires.file 'permit'
PermitRegistry  = requires.file 'permit_registry'

describe 'Ability' ->
  var abook

  permits = {}

  describe 'permits' ->
    before ->
      PermitRegistry.clear-all!

    context 'kris-ability' ->
      specify 'user permit always present, since ability always has non-empty user' ->
        ability.kris.permits(access.empty).should.eql [permits.user]

      specify 'find 1 extra permit matching admin user access' ->
        ability.kris.permits(access.admin).should.eql [permits.user, permits.admin]

      specify 'find 1 extra permit matching guest user access' ->
        ability.kris.permits(access.guest).should.eql [permits.user, permits.guest]

    context 'guest-ability' ->
      specify 'no permits allow read book' ->
        ability.guest.permits(access.read-book).should.eql []