# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

_ = require 'prelude-ls'
require 'sugar'

normalize = require './normalize'

module.exports = class RuleRepo
  (@name) ->

  can-rules: {}
  cannot-rules: {}

  clear: ->
    @can-rules = {}
    @cannot-rules = {}
    @

  clean: ->
    @clear!

  subject-clazz: (subject)->
    if _.is-type 'Object', subject
      subject-clazz = subject.constructor.display-name
    else
      subject-clazz = subject

  find-matching-subject: (subjects, subject) ->
    clazzes = [subject, subject?.to-lower-case!, subject?.to-lower-case!.camelize!]
    clazzes.any (item) ->
      subjects.index-of(item) != -1

  # TODO: simplify, extract methods?
  match-rule: (act, access-request) ->
    act = act.camelize(true)
    action = access-request.action
    subject = access-request.subject

    subj-clazz = @subject-clazz subject
    rule-container = @container-for act

    action-subjects = rule-container[action]
    return false unless _.is-type 'Array', action-subjects
    @find-matching-subject action-subjects, subj-clazz

  # for now, lets forget about ctx
  add-rule: (rule-container, action, subjects) ->
    throw Error("Container must be an object") unless _.is-type 'Object' rule-container
    rule-subjects = rule-container[action] || []

    subjects = normalize subjects
    rule-subjects = rule-subjects.concat subjects

    rule-container[action] = _.unique rule-subjects # do we need this step?

  container-for: (act) ->
    act = act.to-lower-case!
    c = @["#{act}Rules"]
    throw Error "No valid rule container for: #{act}" unless _.is-type 'Object', c
    c

  # rule-container
  register-rule: (act, actions, subjects) ->
    # TODO: perhaps use new AccessRequest(act, actions, subjects).normalize
    actions = normalize actions

    rule-container = @container-for act # can-rules or cannot-rules

    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @add-rule rule-container, action, subjects


