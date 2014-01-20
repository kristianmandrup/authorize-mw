rek      = require 'rekuire'
requires = rek 'requires'

_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

PermitRegistry  = requires.file 'permit_registry'

PermitMatcher   = requires.file 'permit_matcher'
PermitAllower   = requires.file 'permit_allower'
RuleApplier     = requires.file 'rule_applier'
RuleRepo        = requires.file 'rule_repo'

matchers        = requires.file 'matchers'

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

Util            = requires.file 'util'

Debugger        = requires.file 'debugger'

module.exports = class Permit implements Debugger
  (@name, @description = '') ->
    PermitRegistry.register-permit @
    @rule-repo = new RuleRepo @name
    @applied-rules = false

  permit-matcher-class: PermitMatcher
  rule-applier-class: RuleApplier

  # get a named permit
  @get = (name) ->
    PermitRegistry.get(name)

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
    new PermitAllower @rule-repo, @debugging

  allows: (access-request) ->
    @debug 'permit allows?', access-request
    @allower!.allows access-request

  disallows: (access-request) ->
    @debug 'permit disallows?', access-request
    @allower!.disallows access-request

  # Permit matching
  # ----------------

  # TODO: should do clever caching via md5 hash?
  matching: (access) ->
    new AccessMatcher access

  matcher: (access-request) ->
    new @permit-matcher-class @, access-request, @debugging

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @debug 'matches', access-request
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