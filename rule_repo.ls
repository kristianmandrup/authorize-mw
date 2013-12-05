# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

_ = require 'prelude-ls'
require 'sugar'

normalize = require './normalize'

module.exports = class RuleRepo
  can-rules: {}
  cannot-rules: {}

  match-rule: (act, access-request) ->
    act = act.camelize(true)
    action = access-request.action
    subject = clazz = access-request.subject.constructor.display-name

    rule-container = @container-for act

    action-subjects = rule-container[action]
    return false unless _.is-type 'Array', action-subjects
    action-subjects.index-of(subject) != -1

  # for now, lets forget about ctx
  add-rule: (rule-container, action, subjects) ->
    throw Error("Container must be an object") unless _.is-type 'Object' rule-container
    rule-subjects = rule-container[action] || []
    rule-subjects.push subjects

    rule-container[action] = rule-subjects # do we need this step?

  container-for: (act) ->
    act = act.to-lower-case!
    c = @["#{act}Rules"]
    throw Error "No valid rule container for: #{act}" unless _.is-type 'Object', c
    c

  # rule-container
  register-rule: (act, actions, subjects) ->
    # TODO: perhaps use AccessRequest.normalize
    actions = normalize actions
    subjects = normalize subjects

    rule-container = @container-for act # can-rules or cannot-rules

    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @add-rule rule-container, action, subjects
