_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Util = require './util'
PermitMatcher = require './permit_matcher'

normalize = require './normalize'

module.exports = class Permit
  # class methods/variables
  @permits = []

  @get = (name) ->
    permit = @permits[name] || throw Error("No permit '#{name}' is registered")

  (@name = 'unknown') ->
    @canRules = []
    @cannotRules = []

  use: (obj) ->
    lo.extend @, obj

  matcher: new PermitMatcher(@)
  rule-applier: new RuleApplier(@rules)
  rule-repo: new RuleRepo

  matches: (access) ->
    @matcher.match access

  test-access: (act, access-request) ->
    # try to find matching action/subject combi for canRule in rule-repo
    subj = @rule-repo.match-rule act, access-request
    subj? # true if not null

  # if permit disallows, then it doesn't matter if there is also a rule that allows
  # A cannot rule always wins!
  allows: (access-request) ->
    return false if @disallows access-request
    @test-access 'can', access-request

  # if no explicit cannot rule matches, we assume the user IS NOT disallowed
  disallows: (access-rule) ->
    @test-access 'cannot', access-rule

  can: (actions, subjects, ctx) ->
    @rule-repo.register-can-rule actions, subjects, ctx

  cannot: (actions, subjects, ctx) ->
    @rule-repo.register-cannot-rule actions, subjects, ctx
