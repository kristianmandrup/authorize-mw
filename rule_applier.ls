# Used to apply a set of rules (can and cannot rules)
# typically this is via a rules: key on a permit
# The permit can be setup to either apply all rules, (iterating through the rules object)
# or just apply a subset depending on the context (fx the action of the incoming access-request)

_ = require 'prelude-ls'
require 'sugar'

recurse = (key, val) ->
  switch typeof! val
  when 'Function'
    val!
  when 'Object'
    _.each(val, recurse)

# To apply a rule, means to execute the .can or .cannot statement in order to add one or more entries
# to the corresponding can-rules or cannot-rules object in the rule-rep
module.exports = class RuleApplier
  (@repo, @rules, @access-request) ->

  action: ->
    @access-request.action

  user: ->
    @access-request.user

  ctx: ->
    @access-request.ctx

  can-rules: ->
    @repo.can-rules

  cannot-rules: ->
    @repo.cannot-rules

  # execute all rules of a particular name (optionally within specific context, such as area, action or role)
  #
  # context:
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
    rules = @rules
    if _.is-type 'String', context
      rules = @rules[context] if _.is-type 'Object' @rules[context]

    named-rules = rules[name]
    if _.is-type 'Function', named-rules
      named-rules.call @, @access-request
    else
      # just ignore it ;)
      # throw Error "rules key for #{name} should be a function that resolves one or more rules"

  # for more advances cases, also pass context 'action' as 2nd param
  apply-action-rules: ->
    @apply-rules-for @action

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

  apply-rules: ->
    switch typeof @rules
    when 'Function'
      @rules!
    when 'Object'
      if _.is-type 'Object', @access-request
        @apply-access-rules!
      else
        @apply-rules-for 'default'
    else
      throw Error "rules must be a Function or an Object, was: #{@rules}"

  apply-access-rules: ->
    @apply-action-rules
    @apply-user-rules
    @apply-ctx-rules

  # should iterate through rules object recursively and execute any function found
  # using sugar .each: http://sugarjs.com/api
  apply-all-rules: ->
    @rules.each recurse

  # so as not to be same name as can method used "from the outside, ie. via Ability"
  # for the functions within rules object, they are executed with the rule applier as this (@) - ie. the context
  # and thus have @ucan and @ucannot available within that context!
  # for the @apply-action-rules, we could return a function, where the current action is also in the context,
  # and is the default action for all @ucan and @ucannot calls!!
  ucan: (actions, subjects, ctx) ->
    console.log "can", actions, subjects
    @repo.register-rule 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    console.log "cannot", actions, subjects
    @repo.register-rule 'cannot', actions, subjects, ctx


