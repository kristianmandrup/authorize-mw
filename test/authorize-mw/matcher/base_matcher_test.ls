rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

matchers      = requires.file 'matchers'
BaseMatcher   = matchers.BaseMatcher

describe 'BaseMatcher' ->
  var matcher
  var access-request

  before ->
    access-request := {}

  describe 'create' ->
    context 'no access request' ->
      before ->
        matcher  := new MatchMaker

      specify 'must have access request' ->
        matcher.access-request.should.eql {}

    context 'empty access request' ->
      before ->
        matcher        := new MatchMaker access-request

      specify 'must be a user matcher' ->
        matcher.should.be.an.instance-of MatchMaker

      specify 'must have access request' ->
        matcher.access-request.should.eql access-request

      specify 'must have an intersect' ->
        matcher.intersect.should.have.property 'on'





