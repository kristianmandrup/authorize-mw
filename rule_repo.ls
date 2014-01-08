# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

_ = require 'prelude-ls'
require 'sugar'

normalize = require './normalize'

Debugger = require './debugger'

module.exports = class RuleRepo implements Debugger
  (@name) ->

  can-rules: {}
  cannot-rules: {}

  display: ->
    console.log "name:", @name
    console.log "can-rules:", @can-rules
    console.log "cannot-rules:", @cannot-rules

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
    # first try wild-card 'any' or '*'
    return true if subjects.index-of('*') != -1 or subjects.index-of('any')

    unless _.is-type 'String' subject
      throw Error "find-matching-subject: Subject must be a String to be matched, was #{subject}"

    camelized = subject?.camelize true
    camelized.index-of(item) != -1

  # TODO: simplify, extract methods?
  match-rule: (act, access-request) ->
    act = act.camelize(true)
    action = access-request.action
    subject = access-request.subject

    subj-clazz = @subject-clazz subject
    rule-container = @container-for act

    match-manage-rule(rule-container, subj-clazz) if action is 'manage'

    action-subjects = rule-container[action]
    match-subject-clazz action-subjects, subj-clazz

  match-subject-clazz: (action-subjects, subj-clazz) ->
    return false unless _.is-type 'Array', action-subjects
    @find-matching-subject action-subjects, subj-clazz

  match-manage-rule: (rule-container, subj-clazz) ->
    manage-subjects = rule-container['manage']

    found = match-subject-clazz manage-subjects, subj-clazz

    return found if found

    # see if we are allowed to create, edit and delete for this subject class!
    manage-action-subjects(rule-container).all (action-subjects) ->
      match-subject-clazz action-subjects, subj-clazz

  manage-action-subjects: (rule-container) ->
    ['create', 'edit', 'delete'].map (action) ->
      rule-container[action]

  # for now, lets forget about ctx
  add-rule: (rule-container, action, subjects) ->
    throw Error("Container must be an object") unless _.is-type 'Object' rule-container
    rule-subjects = rule-container[action] || []

    subjects = normalize subjects
    rule-subjects = rule-subjects.concat subjects

    rule-subjects = rule-subjects.map (subject) ->
      subject.camelize true

    unique-subjects = _.unique rule-subjects

    rule-container[action] = unique-subjects

    if action is 'manage'
      ['create', 'edit', 'delete'].each (action) ->
        rule-container[action] = unique-subjects

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


