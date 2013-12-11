_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Util = require './util'

PermitMatcher = require './permit_matcher'
PermitAllower = require './permit_allower'
RuleApplier   = require './rule_applier'
RuleRepo      = require './rule_repo'

valid_rules = (rules)->
  _.is-type('Object', rules) or _.is-type('Function', rules)

module.exports = class Permit
  # class methods/variables
  @permits = []

  @clear_permits = ->
    @@permits = []

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

  # used by permit-for to extend specific permit from base class (prototype)
  use: (obj) ->
    obj = obj! if _.is-type 'Function', obj
    if _.is-type 'Object', obj
      lo.extend @, obj
    else throw Error "Can only extend permit with an Object, was: #{typeof obj}"

  rules: ->

  permit-matcher-class: PermitMatcher
  matcher: (access-request) ->
    new @permit-matcher-class @, access-request

  rule-applier-class: RuleApplier
  rule-applier: (access-request) ->
    access-request = null unless _.is-type 'Object', access-request
    new @rule-applier-class @rule-repo, @rules, access-request

  rule-repo:    new RuleRepo
  allower:      new PermitAllower @rule-repo

  clear: ->
    @rule-repo.clear!

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
