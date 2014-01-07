_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Util = require './util'

PermitMatcher = require './permit_matcher'
PermitAllower = require './permit_allower'
RuleApplier   = require './rule_applier'
RuleRepo      = require './rule_repo'

matchers      = require './permit_match_maker'

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

valid_rules = (rules)->
  _.is-type('Object', rules) or _.is-type('Function', rules)

module.exports = class Permit
  # class methods/variables
  @permits = []

  @clear-permits = ->
    @@permits = []

  @clean-permits = ->
    for permit in @@permits
      permit.clear!

  @clean-all = ->
    @@clean-permits!

  permit-matcher-class: PermitMatcher
  rule-applier-class: RuleApplier
  rule-repo: new RuleRepo

  # get a named permit
  @get = (name) ->
    @permits[name] || throw Error("No permit '#{name}' is registered")

  (@name = 'unknown', @description = '') ->
    unless _.is-type 'String', @name
      throw Error "Name of permit must be a String, was: #{@name}"

  init: ->
    if valid_rules @rules
      # apply static rules
      @apply-rules!
    else
      throw Error "No rules defined for permit: #{@name}"
    @

  clear: ->
    @rule-repo.clear!

  # used by permit-for to extend specific permit from base class (prototype)
  use: (obj) ->
    obj = obj! if _.is-type 'Function', obj
    if _.is-type 'Object', obj
      lo.extend @, obj
    else throw Error "Can only extend permit with an Object, was: #{typeof obj}"

  rules: ->

  matcher: (access-request) ->
    new @permit-matcher-class @, access-request

  rule-applier: (access-request) ->
    access-request = null unless _.is-type 'Object', access-request
    new @rule-applier-class @rule-repo, @rules, access-request

  allower: ->
    new PermitAllower @rule-repo

  allows: (access-request) ->
    @allower!.allows access-request

  disallows: (access-request) ->
    @allower!.disallows access-request

  # TODO: should do clever caching via md5 hash?
  matching: (access) ->
    new AccessMatcher access

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @matcher(access-request).match!

  # always called (can be overridden for custom behavior)
  apply-rules: (access-request) ->
    @rule-applier(access-request).apply-rules!

  can-rules: ->
    @rule-repo.can-rules
  cannot-rules: ->
    @rule-repo.cannot-rules
