# Used to apply a set of rules (can and cannot rules)
# typically this is via a rules: key on a permit
# The permit can be setup to either apply all rules, (iterating through the rules object)
# or just apply a subset depending on the context (fx the action of the incoming access-request)

_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Debugger = require './debugger'

recurse = (key, val, ctx) ->
  switch typeof! val
  when 'Function'
    val.call ctx
  when 'Object'
    _.each(val, recurse, ctx)

valid_rules = (rules)->
  _.is-type('Object', rules) or _.is-type('Function', rules)

# To apply a rule, means to execute the .can or .cannot statement in order to add one or more entries
# to the corresponding can-rules or cannot-rules object in the rule-rep
module.exports = class RuleApplier implements Debugger
  (@repo, @rules, @access-request) ->
    unless _.is-type('Object', @repo)
      throw Error "RuleApplier must be passed a RuleRepo, was: #{@repo}"

    unless valid_rules @rules
      throw Error "RuleApplier must be passed the rules to be applied, was: #{@rules}"

    unless @access-request is undefined or _.is-type 'Object', @access-request
      throw Error "AccessRequest must be an Object, was: #{@access-request}"

  action: ->
    @access-request?.action

  user: ->
    @access-request?.user

  ctx: ->
    @access-request?.ctx

  can-rules: ->
    @repo.can-rules

  cannot-rules: ->
    @repo.cannot-rules

  # Execute all rules of a particular name (optionally within specific context, such as area, action or role)
  #
  # apply-rules-for 'read', 'action' - will execute the rules in... rules.action.read
  # apply-rules-for 'read' - will execute the rules in rules.read
  #
  #
  # rules:
  #   action:
  #     read: ->
  #     ....
  #   role:
  #     admin: ->
  #     guest: ->
  #   area:
  #     admin: ->
  #     guest: ->
  #     member: ->
  #
  apply-rules-for: (name, context) ->
    rules = @context-rules(context)

    unless _.is-type 'String' name
      @debug "Name to apply rules for must be a String, was: #{typeof name} : #{name}"
      return @
      # throw Error "Name to appl rules for must be a String, was: #{name}"

    named-rules = rules[name]
    if _.is-type 'Function', named-rules
      named-rules.call @, @access-request
    else
      @debug "rules key for #{name} should be a function that resolves one or more rules"
    @

  context-rules: (context)->
    return @rules unless _.is-type 'String', context
    if _.is-type 'Object' @rules[context]
      @rules[context]
    else
      @debug "no such rules context: #{context}"
      @rules


  # for more advances cases, also pass context 'action' as 2nd param
  apply-action-rules: ->
    @apply-rules-for @action!
    @apply-rules-for @action!, 'action'
    @

  # typically used for role specific rules:
  # rules:
  #   admin: ->
  #     @ucan 'manage', '*'
  #
  # apply-rules-for user.role
  #
  # but could also be used for user specific rules,
  # such as on user name, email or whatever, even age (minor < 18y old!?)
  #
  apply-user-rules: ->
    @apply-rules-for @user!
    @apply-rules-for @user!, 'user'
    @

  # such as where on the site is the user?
  # guest area, member area? admin area?
  # which rules should apply?
  # rules:
  #   area:
  #     admin: ->
  #       @ucan 'manage', '*'
  #
  #
  apply-ctx-rules: ->
    @apply-rules-for @ctx!
    @apply-rules-for @ctx!, 'ctx'
    @apply-rules-for @ctx!, 'context'
    @

  apply-default-rules: ->
    if _.is-type 'Object', @access-request
      @apply-access-rules!
    else
      @apply-rules-for 'default'

  apply-rules: ->
    switch typeof @rules
    when 'function'
      @rules!
    when 'object'
      @apply-default-rules!

    else
      throw Error "rules must be a Function or an Object, was: #{@rules}"
    @

  apply-access-rules: ->
    @apply-action-rules!
    @apply-user-rules!
    @apply-ctx-rules!
    @

  # should iterate through rules object recursively and execute any function found
  # using sugar .each: http://sugarjs.com/api
  apply-all-rules: ->
    switch typeof @rules
    when 'object'
      rules = @rules
      ctx = @
      _.keys(rules).each (key) ->
        recurse key, rules[key], ctx
    else
      throw Error "rules must be an Object was: #{typeof @rules}"
    @

  # so as not to be same name as can method used "from the outside, ie. via Ability"
  # for the functions within rules object, they are executed with the rule applier as this (@) - ie. the context
  # and thus have @ucan and @ucannot available within that context!
  # for the @apply-action-rules, we could return a function, where the current action is also in the context,
  # and is the default action for all @ucan and @ucannot calls!!
  ucan: (actions, subjects, ctx) ->
    @repo.register-rule 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    @repo.register-rule 'cannot', actions, subjects, ctx


lo.extend RuleApplier, Debugger