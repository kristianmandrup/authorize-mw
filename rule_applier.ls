# Used to apply a set of rules (can and cannot rules)
# typically this is via a rules: key on a permit
# The permit can be setup to either apply all rules, (iterating through the rules object)
# or just apply a subset depending on the context (fx the action of the incoming access-request)

recurse = (key, val) ->
  switch typeof! val
  when 'Function'
    val!
  when 'Object'
    _.each(val, recurse)
  else
    # nothing

module.exports = class RuleApplier
  (@rules) ->

# execute all rules to add can and cannot rules for given access context
  apply-rules-for: (name, access) ->
    rules = @rules[name]
    rules access if _is-type 'Function', rules

  apply-action-rules-for: (access-request) ->
    @apply-rules-for access-request.action, access

  apply-default-rules: (access) ->
    @apply-rules-for 'default', access

  # should iterate through rules object recursively and execute any function found
  # using sugar .each: http://sugarjs.com/api
  apply-all-rules: ->
    @rules.each recurse



