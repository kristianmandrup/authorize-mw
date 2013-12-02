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

  canRules: []
  cannotRules: []

  matcher: new PermitMatcher(@)

  matches: (access) ->
    matcher.match access

  testRule: (rule) ->
    subj = canActRule[rule.subject]
    ctxRule = canActRule[rule.ctx]
    clazz = rule.subject.type # if no type, can we detect type on structure alone?
    if ctxRule
      return ctxRule(rule) if _.is-type 'Function', ctxRule
    else 
      return true if subj is clazz and not ctxRule
    # if no rule match
    false

  # TODO
  # 
  allows: (rule) ->
    return false if @disallows(rule)
    canActRule = @canRules[rule.action]
    @testRule(canActRule)

  # TODO: use same approach as allows
  disallows: (rule) -> 
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
    subject = normalize subjects
    for action in actions
      for subject in subjects
        @addRule ruleList, action, subject, ctx

  can: (actions, subjects, ctx) ->
    @registerRule @canRules, actions, subjects, ctx

  cannot: (actions, subjects, ctx) ->
    @registerRule @cannotRules, actions, subjects, ctx

  addRule: (list, action, subject, ctx) ->
      actRule = list[action] || []
      actRule.push {subject: subject, ctx: ctx}
      list[action] = actRule



 
