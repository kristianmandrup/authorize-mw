_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Util = require './util'

PermitRegistry  = require './permit_registry'
PermitMatcher   = require './permit_matcher'
PermitAllower   = require './permit_allower'
RuleApplier     = require './rule_applier'
RuleRepo        = require './rule_repo'

matchers        = require './matchers'

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

Debugger = require './debugger'

valid_rules = (rules)->
  _.is-type('Object', rules) or _.is-type('Function', rules)

module.exports = class Permit implements Debugger
  (@name, @description = '') ->
    PermitRegistry.register-permit @
    @rule-repo = new RuleRepo @name

  permit-matcher-class: PermitMatcher
  rule-applier-class: RuleApplier

  # get a named permit
  @get = (name) ->
    PermitRegistry.permits[name] || throw Error("No permit '#{name}' is registered")

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

  # default empty rules
  rules: ->

  # Access allowance
  # ----------------

  allower: ->
    new PermitAllower @rule-repo

  allows: (access-request) ->
    @allower!.allows access-request

  disallows: (access-request) ->
    @allower!.disallows access-request

  # Permit matching
  # ----------------

  # TODO: should do clever caching via md5 hash?
  matching: (access) ->
    new AccessMatcher access

  matcher: (access-request) ->
    new @permit-matcher-class @, access-request

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @matcher(access-request).match!

  # Rule Application
  # ----------------

  rule-applier: (access-request) ->
    access-request = null unless _.is-type 'Object', access-request
    new @rule-applier-class @rule-repo, @rules, access-request

  # always called (can be overridden for custom behavior)
  apply-rules: (access-request) ->
    unless @applied-rules
      @rule-applier(access-request).apply-rules!
    @applied-rules = true

  can-rules: ->
    @rule-repo.can-rules
  cannot-rules: ->
    @rule-repo.cannot-rules
