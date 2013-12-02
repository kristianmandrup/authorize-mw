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


describe 'Permit init' ->
  var access, guest-permit, admin-permit

  before ->
    guest-permit    := new GuestPermit
    admin-permit    := new AdminPermit

    access =
      user:
        role: 'admin'


  specify 'creates a permit with the name unknown' ->
    permit.name.should.be('unknown')

  specify 'creates a permit with an Intersect' ->
    permit.intersect.should.be.instanceOf(Object).and.have.property('on')

describe 'Permit init' ->
  var permit

  before ->
    permit := new Permit 'hello'

  specify 'has an empty canRules list' ->
    permit.canRules.should.be.empty

  specify 'has an empty cannotRules list' ->
    permit.cannotRules.should.be.empty

###
describe 'Permit matching' ->
  specify 'matches an accesObj if no match rules or match function' ->

  specify 'matches an accesObj on includes' ->

  specify 'does not match an accesObj if excludes function matches' ->

  specify 'does not match an accesObj if both includes an excludes function matches' ->

  specify 'matches if match function matches and no includes or excludes function' ->

describe 'Permit rule registration' ->
  specify 'registers a valid rule' ->

  specify 'does not registers an invalid rule' ->
###

