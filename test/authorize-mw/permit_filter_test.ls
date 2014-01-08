rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_         = require 'prelude-ls'

User      = requires.fix 'user'
Book      = requires.fix 'book'

Permit        = requires.file 'permit'
permit-for    = requires.file 'permit_for'
PermitFilter  = requires.file 'permit_filter'

describe 'permit-filter' ->
  before ->
    #

  describe 'user filter' ->
    var user, user-permit, access-request
    
    before ->
      user  := new User name: 'Javier'
      access-request := {user: user}

      Permit.clear-permits!
      
      user-permit := permit-for 'User',
        match: (access) ->
          @matching(access).has-user

    specify 'return only permits that apply for a user' ->
      PermitFilter.filter(access-request).should.eql [user-permit]

  describe 'guest user filter' ->
    var guest-user, guest-permit, admin-permit, access-request
    before ->
      guest-user  := new User role: 'guest'
      access-request := {user: guest-user}

      Permit.clear-permits!

      guest-permit := permit-for 'Guest',
        match: (access) ->
          @matching(access).has-role 'guest'

      admin-permit := permit-for 'Admin',
        match: (access) ->
          @matching(access).has-role 'admin'

    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(access-request).should.eql [guest-permit]
      
  xdescribe 'admin user filter' ->
    var admin-user, guest-permit, admin-permit, access-request
    before ->
      admin-user  := new User role: 'admin'
      access-request := {user: admin-user}

      Permit.clear-permits!

      guest-permit := permit-for 'Guest',
        match: (access) ->
          @matching(access).has-role: 'guest'

      admin-permit := permit-for 'Admin',
        match: (access) ->
          @matching(access).has-role: 'admin'

    specify 'return only permits that apply for an admin user' ->
      PermitFilter.filter(access-request).should.eql [admin-permit]
