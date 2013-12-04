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

  matches: (access) ->
    @matcher.match access

  # TODO: Fix it!!!
  testRule: (rule) ->
    subj = canActRule[rule.subject]
    ctxRule = canActRule[rule.ctx]
    clazz = rule.subject.constructor.display-name
    if ctxRule
      return ctxRule(rule) if _.is-type 'Function', ctxRule
    else 
      return true if subj is clazz and not ctxRule
    # if no rule match
    false

  # TODO
  # 
  allows: (access-rule) ->
    return false if @disallows(access-rule)
    canActRule = @canRules[access-rule.action]
    @testRule(canActRule)

  # TODO: use same approach as allows
  disallows: (access-rule) ->
    cannotActRule = @cannotRules[rule.action]
    @testRule(cannotActRule)

  rule-applier: new RuleApplier(@rules)

  rule-repo: new RuleRepo

  can: (actions, subjects, ctx) ->
    @rule-repo.register-can-rule actions, subjects, ctx

  cannot: (actions, subjects, ctx) ->
    @rule-repo.register-cannot-rule actions, subjects, ctx
