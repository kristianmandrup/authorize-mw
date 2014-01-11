rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_         = require 'prelude-ls'

User      = requires.fix 'user'
Book      = requires.fix 'book'

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

PermitRegistry  = requires.file 'permit_registry'
Permit          = requires.file 'permit'
permit-for      = requires.file 'permit_for'
PermitFilter    = requires.file 'permit_filter'

describe 'permit-filter' ->
  permits = {}
  users   = {}

  describe 'user filter' ->
    var access-request
    
    before ->
      users.javier  := create-user.javier
      access-request :=
        user: user

      PermitRegistry.clear-all!
      permits.user := create-permit.matching.user!

    specify 'return only permits that apply for a user' ->
      PermitFilter.filter(access-request).should.eql [user-permit]

  describe 'guest user filter' ->
    var access-request
    before ->
      users.guest  := create-user.guest
      access-request :=
        user: guest-user

      PermitRegistry.clear-all!
      permits.guest := create-permit.matching.guest!
      permits.admin := create-permit.matching.admin!

    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(access-request).should.eql [guest-permit]
      
  xdescribe 'admin user filter' ->
    var admin-user, guest-permit, admin-permit, access-request
    before ->
      users.admin  := create-user.admin
      access-request :=
        user: users.admin

      PermitRegistry.clear-all!

      permits.guest := create-permit.matching.guest!
      permits.admin := create-permit.matching.admin!

    specify 'return only permits that apply for an admin user' ->
      PermitFilter.filter(access-request).should.eql [admin-permit]
