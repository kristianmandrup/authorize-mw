module.exports = class RuleApplier
  (@rules) ->

# execute all rules to add can and cannot rules for given access context
  applyRulesFor: (name, access) ->
    rules = @rules[name]
    rules(access) if type(rules) is 'function'

  applyActionRulesFor: (access) ->
    @applyRulesFor(access.action, access)

  applyDefaultRules: (access) ->
    @applyRulesFor('default', access)
