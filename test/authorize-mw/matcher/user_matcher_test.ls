rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

User            = requires.fix 'user'
matchers        = requires.file 'matchers'

UserMatcher   = matchers.UserMatcher

describe 'UserMatcher' ->
  var user-matcher
  var admin-access-request
  var admin-user

  before ->
    admin-user := new User name: 'kris' role: 'admin'
    admin-access-request :=
      user: admin-user

  describe 'create' ->
    before ->
      user-matcher  := new UserMatcher admin-access-request

    specify 'must be a user matcher' ->
      user-matcher.should.be.an.instance-of UserMatcher

    specify 'must have admin access request' ->
      user-matcher.access-request.should.eql admin-access-request

  describe 'match' ->
    before-each ->
      user-matcher  := new UserMatcher admin-access-request

    specify 'should match admin role' ->
      user-matcher.match(role : 'admin').should.be.true

    specify 'should NOT match guest role' ->
      user-matcher.match(role: 'guest').should.be.false

    specify 'should match on no argument' ->
      user-matcher.match!.should.be.true