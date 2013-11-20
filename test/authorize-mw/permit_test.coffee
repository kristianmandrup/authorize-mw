require '../test_setup'

Intersect = require '../../intersect'
Permit = require '../../permit'

describe 'Permit init - no args', ->
  permit = null

  before( ->
    permit = new Permit()
  )

  it 'creates a permit with the name unknown', ->
    permit.name.should.be('unknown')

  it 'creates a permit with an Intersect', ->
    permit.intersect.should.be.instanceOf(Object).and.have.property('on')

describe 'Permit init', ->
  permit = null

  before( ->
    permit = new Permit('hello')
  )

  it 'creates a permit with an Intersect', ->

  it 'has an empty canRules list', ->

  it 'has an empty cannotRules list', ->

###
describe 'Permit matching', ->
  it 'matches an accesObj if no match rules or match function', ->

  it 'matches an accesObj on includes', ->

  it 'does not match an accesObj if excludes function matches', ->

  it 'does not match an accesObj if both includes an excludes function matches', ->

  it 'matches if match function matches and no includes or excludes function', ->

describe 'Permit rule registration', ->
  it 'registers a valid rule', ->

  it 'does not registers an invalid rule', ->
###

