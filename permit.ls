_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

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

Util            = require './util'

Debugger        = require './debugger'

module.exports = class Permit implements Debugger
  (@name, @description = '') ->
    PermitRegistry.register-permit @
    @rule-repo = new RuleRepo @name
    @applied-rules = false

  permit-matcher-class: PermitMatcher
  rule-applier-class: RuleApplier

  # get a named permit
  @get = (name) ->
    PermitRegistry.permits[name] || throw Error("No permit '#{name}' is registered")

  init: ->
    @apply-rules!
    @

  clean: ->
    @debug 'clean'
    @rule-repo.clean!
    @applied-rules = false

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
    access-request = {} unless _.is-type 'Object', access-request
    new @rule-applier-class @rule-repo, @rules, access-request, @debugging

  # always called (can be overridden for custom behavior)
  apply-rules: (access-request, force) ->
    unless access-request is undefined or _.is-type 'Object', access-request
      force = Boolean access-request
    unless @applied-rules and not force
      @debug 'permit apply rules', access-request
      @rule-applier(access-request).apply-rules!
      @applied-rules = true
    else
      @debug 'rules already applied before', @applied-rules

  can-rules: ->
    @rule-repo.can-rules

  cannot-rules: ->
    @rule-repo.cannot-rules

lo.extend Permit, Debugger