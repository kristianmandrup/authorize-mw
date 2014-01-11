rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'

create-permit   = requires.fac 'create-permit'
create-request  = requires.fac 'create-request'

ability         = require './abilities'

Ability         = requires.file 'ability'
Permit          = requires.file 'permit'
PermitRegistry  = requires.file 'permit_registry'

permit-filter   = requires.file 'permit-filter'

describe 'Ability' ->
  var abook

  permits = {}

  describe 'permits' ->
    before ->
      PermitRegistry.clear-all!
      permits.user    = create-permit.user!
      permits.guest   = create-permit.guest!
      permits.admin   = create-permit.admin!

    context 'kris-ability' ->
      describe 'permit-filter' ->
        specify 'user permit never filtered out' ->
          permit-filter.filter(access.empty).should.eql [permits.user]


      specify 'user permit always present, since ability always has non-empty user' ->
        ability.kris.permits(access.empty).should.eql [permits.user]

      xspecify 'find 1 extra permit matching admin user access' ->
        ability.kris.permits(access.admin).should.eql [permits.user, permits.admin]

      xspecify 'find 1 extra permit matching guest user access' ->
        ability.kris.permits(access.guest).should.eql [permits.user, permits.guest]

    context 'guest-ability' ->
      xspecify 'no permits allow read book' ->
        ability.guest.permits(access.read-book).should.eql []