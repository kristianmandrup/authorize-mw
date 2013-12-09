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

  # execute all rules of a particular name
  # not sure we should use the access-request here, just a wild idea!
  apply-rules-for: (name) ->
    named-rules = @rules[name]
    if _.is-type 'Function', named-rules
      named-rules.call @, @access-request
    else
      throw Error "rules key for #{name} should be a function that resolves one or more rules"

  apply-action-rules: ->
    @apply-rules-for @action

  apply-user-rules: ->

  apply-ctx-rules: ->

  apply-static-rules: ->
    apply-rules-for 'default'

  apply-dynamic-rules: (access-request) ->
    @apply-action-rules
    @apply-user-rules
    @apply-ctx-rules

  # should iterate through rules object recursively and execute any function found
  # using sugar .each: http://sugarjs.com/api
  apply-all-rules: ->
    @rules.each recurse

  # so as not to be same name as can method used "from the outside, ie. via Ability"
  ucan: (actions, subjects, ctx) ->
    console.log "can", actions, subjects
    @repo.register-rule 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    console.log "cannot", actions, subjects
    @repo.register-rule 'cannot', actions, subjects, ctx


