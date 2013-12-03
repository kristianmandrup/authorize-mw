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
    matcher.match access

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

  # execute all rules to add can and cannot rules for given access context
  applyRulesFor: (name, access) ->
    rules = @rules[name]
    rules(access) if type(rules) is 'function'

  applyActionRulesFor: (access) ->
    @applyRulesFor(access.action, access)

  applyDefaultRules: (access) ->
    @applyRulesFor('default', access)

  registerRule: (ruleList, actions, subjects, ctx) ->
    actions = normalize actions
    subjects = normalize subjects
    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @addRule ruleList, action, subjects, ctx

  canRules: []
  cannotRules: []

  can: (actions, subjects, ctx) ->
    @registerRule @canRules, actions, subjects, ctx

  cannot: (actions, subjects, ctx) ->
    @registerRule @cannotRules, actions, subjects, ctx

  addRule: (list, action, subjects, ctx) ->
      actRule = list[action] || []
      actRule.push {subject: subjects, ctx: ctx}
      list[action] = actRule



 
