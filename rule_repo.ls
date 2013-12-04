# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

_ = require 'prelude-ls'

normalize = require './normalize'

module.export = class RuleRepo
  can-rules: {}
  cannot-rules: {}

  match-rule: (act, access-request) ->
    act = act.camelize(true)
    action = access-request.action
    subject = clazz = access-request.subject.constructor.display-name

    action-subjects = @["#{act}Rules"][action]
    _.find subject, action-subjects

  # for now, lets forget about ctx
  add-rule: (rule-container, action, subjects) ->
    rule-subjects = rule-container[action] || []
    rule-subjects.push subjects

    rule-container[action] = rule-subjects # do we need this step?

  container-for: (act) ->
    act = act.to-lower-case!
    @["#{act}Rules"]

  # rule-container
  register-rule: (act, actions, subjects) ->
    actions = normalize actions
    subjects = normalize subjects
    rule-container = container-for act # can-rules or cannot-rules
    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @add-rule rule-container, action, subjects
