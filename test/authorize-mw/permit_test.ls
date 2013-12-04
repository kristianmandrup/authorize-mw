require '../test_setup'

_         = require 'prelude-ls'
Permit    = require '../../permit'

class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  constructor: ->
    super

  match: (access) ->
    true


describe 'Permit' ->
  var access, guest-permit, admin-permit

  before ->
    guest-permit    := new GuestPermit
    admin-permit    := new AdminPermit

    access =
      user:
        role: 'admin'


  describe 'init' ->
    specify 'creates a permit with the name unknown' ->
      permit.name.should.be('unknown')

    specify 'creates a permit with an Intersect' ->
      permit.intersect.should.be.instanceOf(Object).and.have.property('on')

  describe 'rules' ->
    var permit

    before ->
      permit := new Permit 'hello'

    specify 'has an empty canRules list' ->
      permit.can-rules!.should.be.empty

    specify 'has an empty cannotRules list' ->
      permit.cannot-rules!.should.be.empty

  describe 'matches' ->

  describe 'Permit rule registration' ->
    specify 'registers a valid rule' ->

    specify 'does not registers an invalid rule' ->


