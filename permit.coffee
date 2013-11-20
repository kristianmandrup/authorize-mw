_ = require 'lodash'
Mixin = require './mixin'
require 'sugar'

Intersect = require './intersect'
Util = require './util'

module.exports = class Permit extends Mixin
  # class methods/variables
  @permits = []

  @get: (name) ->
    permit = @permits[name] || throw new Error("No permit '#{name}' is registered")

  constructor: (@name) ->
    @intersect = Intersect()
    @canRules = []
    @cannotRules = []

  canRules: []
  cannotRules: []

  matches: (access) ->
    # use object intersection test if permit has includes or excludes
    matchInclude = true
    if @match? && @match typeof Function
      matchInclude = @match access

    matchExclude = false
    if @exMatch? && @exMatch typeof Function
      matchExclude = @exMatch access

    # call function if function, otherwise use static value
    res = {}
    res.include = @intersectOn @includes
    res.exclude = @intersectOn @excludes
    (res.include or matchInclude) and not (res.exclude or matchExclude)

  intersectOn: (item) ->
    if item?
      return @intersect.on access, item() if item typeof Function
      @intersect.on access, item

  testRule: (rule) ->
    subj = canActRule[rule.subject]
    ctxRule = canActRule[rule.ctx]
    clazz = rule.subject.type # if no type, can we detect type on structure alone?
    if ctxRule
      return ctxRule(rule) if type(ctxRule) is 'function'
    else 
      return true if subj is clazz and not ctxRule
    # if no rule match
    false

  # TODO
  # 
  allows: (rule, ctx) ->
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

  normalize: (items) ->
    switch type(items)
      when 'function'
        items()
      when 'string'
        [items]
      when 'array'
        items.map(
          (item) -> @normalize item
        )
      else
        throw new Error("#{action} can't be normalized, must be a Function, String or Array")

  registerRule: (ruleList, actions, subjects, ctx) ->
    actions = @normalize actions
    subject = @normalize subjects
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


class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  constructor: ->
    super

  match: (access) ->
    true

access = 
  user:
    role: 'admin'
 
admPermit   = new AdminPermit
guestPermit = new GuestPermit

console.log admPermit.matches access
console.log guestPermit.matches access
 
