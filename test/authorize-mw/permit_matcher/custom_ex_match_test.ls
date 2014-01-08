requires = require('rekuire') 'requires'
requires.test 'test_setup'

[Book, User] = requires.fixtures 'book', 'user'
[permit-for, PermitMatcher, Permit, PermitRegistry] = require.files 'permit-for', 'permit_matcher', 'permit', 'permit-registry'

setup           = require('./permits').setup

describe 'PermitMatcher' ->
  describe 'custom-ex-match' ->
    var ex-user-permit
    var access-request, user-access-request, access-request-alt

    matching = {}
    none-matching = {}

    before ->
      user-access-request :=
        user: {role: 'admin'}

      access-request :=
        ctx: void

      PermitRegistry.clear-all!
      ex-user-permit := setup.ex-user-permit!

      # should match since the ex-user-permit has an ex-match method that matches on has-role 'admin'
      matching.permit-matcher       := new PermitMatcher ex-user-permit, user-access-request

      none-matching.permit-matcher  := new PermitMatcher ex-user-permit, access-request

    specify 'matches access-request using permit.ex-match' ->
      matching.permit-matcher.custom-ex-match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-ex-match!.should.be.false

    describe 'invalid ex-match method' ->
      before ->
        ex-user-permit := setup.invalid-ex-user!

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-ex-match ).should.throw