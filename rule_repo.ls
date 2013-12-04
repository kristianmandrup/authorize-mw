module.export = class RuleRepo
  canRules: []
  cannotRules: []

  add-rule: (list, action, subjects, ctx) ->
    actRule = list[action] || []
    actRule.push {subject: subjects, ctx: ctx}
    list[action] = actRule

  register-rule: (ruleList, actions, subjects, ctx) ->
    actions = normalize actions
    subjects = normalize subjects
    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @addRule ruleList, action, subjects, ctx

  register-can-rule: (actions, subjects, ctx) ->
    register-rule @canRules, actions, subjects, ctx

  register-cannot-rule: (actions, subjects, ctx) ->
    register-rule @cannotRules, actions, subjects, ctx