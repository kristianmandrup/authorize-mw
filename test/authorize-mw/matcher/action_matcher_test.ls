require '../test_setup'

matchers      = require '../../matchers'
ActionMatcher = matchers.ActionMatcher

describe 'ActionMatcher' ->
  var action-matcher

  var read-access-request

  before ->
    read-access-request :=
      action: 'read'

  describe 'create' ->
    before-each ->
      action-matcher  := new ActionMatcher read-access-request

    specify 'must have admin access request' ->
      action-matcher.access-request.should.eql read-access-request

  describe 'match' ->
    before-each ->
      action-matcher  := new ActionMatcher read-access-request

    specify 'should match read action' ->
      action-matcher.match('read').should.be.true

    specify 'should NOT match write action' ->
      action-matcher.match('write').should.be.false

    specify 'should match on no argument' ->
      action-matcher.match!.should.be.true