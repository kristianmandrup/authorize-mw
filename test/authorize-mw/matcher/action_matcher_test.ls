rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

matchers      = requires.file 'matchers'
ActionMatcher = matchers.ActionMatcher

describe 'ActionMatcher' ->
  var action-matcher

  requests = {}

  before ->
    requests.read :=
      action: 'read'

  describe 'create' ->
    before-each ->
      action-matcher  := new ActionMatcher requests.read

    specify 'must have admin access request' ->
      action-matcher.access-request.should.eql requests.read

  describe 'match' ->
    before-each ->
      action-matcher  := new ActionMatcher requests.read

    specify 'should match read action' ->
      action-matcher.match('read').should.be.true

    specify 'should NOT match write action' ->
      action-matcher.match('write').should.be.false

    specify 'should match on no argument' ->
      action-matcher.match!.should.be.true