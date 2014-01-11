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

  permits   = {}
  requests  = {}

  describe 'permits' ->
    before ->
      abook := new Book title: 'book'

      PermitRegistry.clear-all!
      permits.user    = create-permit.matching.user!
      permits.guest   = create-permit.matching.role.guest!
      permits.admin   = create-permit.matching.role.admin!

      requests.empty      = create-request.empty!
      requests.admin      = create-request.role-access 'admin'
      requests.guest      = create-request.role-access 'guest'
      requests.read-book  =
        action: 'read'
        subject: abook

    context 'kris-ability' ->
      describe 'permit-filter' ->
        specify 'user permit never filtered out' ->
          permit-filter.filter(requests.empty).should.eql [permits.user]

      xspecify 'user permit always present, since ability always has non-empty user' ->
        ability.kris.permits(requests.empty).should.eql [permits.user]

      xspecify 'find 1 extra permit matching admin user access' ->
        ability.kris.permits(requests.admin).should.eql [permits.user, permits.admin]

      xspecify 'find 1 extra permit matching guest user access' ->
        ability.kris.permits(requests.guest).should.eql [permits.user, permits.guest]

    context 'guest-ability' ->
      xspecify 'no permits allow read book' ->
        ability.guest.permits(requests.read-book).should.eql []