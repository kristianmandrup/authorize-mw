# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

require 'sugar'

module.export = class RuleRepo
  can-rules: {}
  cannot-rules: {}

  match-rule: (act, access-request) ->
    act = act.camelize(true)
    action = access-request.action
    subject = clazz = access-request.subject.constructor.display-name

    # call matchCan or matchCannot
    @["match#{act}"] action, subject

  # will try to find a matching subject for the key of the action in the
  match-can: (action, subject) ->
    act-rule = @can-rules[action]
    _.find act-rule, subject

  # will try to find a matching subject for the key of the action in the
  match-cannot: (action, subject) ->
    act-rule = @cannot-rules[action]
    _.find act-rule subject

  add-rule: (list, action, subjects, ctx) ->
    actRule = list[action] || []
    actRule.push {subject: subjects, ctx: ctx}
    list[action] = actRule

  register-rule: (rule-list, actions, subjects, ctx) ->
    actions = normalize actions
    subjects = normalize subjects
    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @addRule rule-list, action, subjects, ctx

  # TODO: not sure yet how to use the ctx - see CanCan for inspiration!
  register-can-rule: (actions, subjects, ctx) ->
    register-rule @can-rules, actions, subjects, ctx

  register-cannot-rule: (actions, subjects, ctx) ->
    register-rule @cannot-rules, actions, subjects, ctx