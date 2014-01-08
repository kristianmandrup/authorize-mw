require '../test_setup'

_             = require 'prelude-ls'

Book          = require '../fixtures/book'
User          = require '../fixtures/user'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'
Permit        = require '../../permit'
setup         = require('./permits').setup

describe 'PermitMatcher' ->
  var user-kris, user-emily
  var user-permit, guest-permit, admin-permit
  
  matching = {}
  none-matching = {}
  
  var permit-matcher
  var userless-access, user-access

  before ->
    user-kris   := new User name: 'kris'
    user-emily  := new User name: 'emily'

    userless-access := {ctx: {area: 'guest'}}
    user-access     := {user: user-kris}

    user-permit     := setup.user-permit
    permit-matcher  := new PermitMatcher user-permit, user-access

  describe 'init' ->
    specify 'has user-permit' ->
      permit-matcher.permit.should.eql user-permit

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      permit-matcher.intersect-on(user-access).should.be.true







