require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

permit-for    = require '../../permit_for'
PermitFilter  = require '../../permit_filter'

describe 'permit-filter' ->
  before ->
    #

  describe 'user filter' ->
    var user, user-permit
    
    before ->
      user  := new User name: 'Javier'
      user-permit := permit-for 'User',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
      
    specify 'return only permits that apply for a user' ->
      PermitFilter.filter(guest-user).should.eql [user-permit]      

  describe 'guest user filter' ->
    var guest-user, guest-permit      
    before ->
      guest-user  := new User role: 'guest'
      guest-permit := permit-for 'Guest',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'guest'
      
    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(guest-user).should.eql [guest-permit]
      
  describe 'admin user filter' ->
    var admin-user, admin-permit      
    before ->
      admin-user  := new User role: 'admin'
      admin-permit = permit-for 'Admin',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'admin'
      

    specify 'return only permits that apply for an admin user' ->
      PermitFilter.filter(admin-user).should.eql [admin-permit]
