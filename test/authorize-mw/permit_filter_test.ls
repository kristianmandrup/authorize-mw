require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

Permit        = require '../../permit'
permit-for    = require '../../permit_for'
PermitFilter  = require '../../permit_filter'

describe 'permit-filter' ->
  before ->
    #

  describe 'user filter' ->
    var user, user-permit, access-request
    
    before ->
      user  := new User name: 'Javier'
      access-request := {user: user}
      user-permit := permit-for 'User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object' user
      
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
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'guest'

      admin-permit := permit-for 'Admin',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'admin'

    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(access-request).should.eql [guest-permit]
      
  describe 'admin user filter' ->
    var admin-user, guest-permit, admin-permit, access-request
    before ->
      admin-user  := new User role: 'admin'
      access-request := {user: admin-user}

      Permit.clear-permits!

      guest-permit := permit-for 'Guest',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'guest'

      admin-permit := permit-for 'Admin',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'admin'

    specify 'return only permits that apply for an admin user' ->
      PermitFilter.filter(access-request).should.eql [admin-permit]
