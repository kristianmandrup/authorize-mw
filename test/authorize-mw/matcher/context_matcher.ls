rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

matchers        = requires.file 'matchers'
ContextMatcher  = matchers.ContextMatcher

describe 'ContextMatcher' ->
  var ctx-matcher
  var visitor-access-request
  var area-ctx

  before ->
    area-ctx := {area: 'visitor' }
    visitor-access-request := {ctx: area-ctx }

  describe 'create' ->
    before-each ->
      ctx-matcher  := new ContextMatcher visitor-access-request

    specify 'must have admin access request' ->
      ctx-matcher.access-request.should.eql visitor-access-request

  describe 'match' ->
    before-each ->
      ctx-matcher  := new ContextMatcher visitor-access-request

    specify 'should match area: visitor' ->
      ctx-matcher.match(area-ctx).should.be.true

    specify 'should NOT match area: member' ->
      ctx-matcher.match(area: 'member').should.be.false

    specify 'should match on no argument' ->
      ctx-matcher.match!.should.be.true

  describe 'match function' ->
    before-each ->
      visitor-access-request :=
        ctx:
          auth: 'yes'

      ctx-matcher  := new ContextMatcher visitor-access-request

    specify 'should match -> auth is yes' ->
      ctx-matcher.match( -> @auth is 'yes').should.be.true