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


# To apply a rule, means to execute the .can or .cannot statement in order to add one or more entries
# to the corresponding can-rules or cannot-rules object in the rule-rep
module.exports = class RuleApplier
  (@repo, @rules) ->

  # execute all rules of a particular name
  # not sure we should use the access-request here, just a wild idea!
  apply-rules-for: (name, access-request) ->
    rules = @rules[name]
    rules access if _is-type 'Function', rules

  apply-action-rules-for: (access-request) ->
    @apply-rules-for access-request.action, access

  # only rules for the default key
  apply-default-rules: (access) ->
    @apply-rules-for 'default', access

  # should iterate through rules object recursively and execute any function found
  # using sugar .each: http://sugarjs.com/api
  apply-all-rules: ->
    @rules.each recurse

  can: (actions, subjects, ctx) ->
    @rule-repo.register-can-rule actions, subjects, ctx

  cannot: (actions, subjects, ctx) ->
    @rule-repo.register-cannot-rule actions, subjects, ctx


