_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Util = require './util'

PermitMatcher = require './permit_matcher'
PermitAllower = require './permit_allower'
RuleApplier   = require './rule_applier'
RuleRepo      = require './rule_repo'

module.exports = class Permit
  # class methods/variables
  @permits = []

  # get a named permit
  @get = (name) ->
    permit = @permits[name] || throw Error("No permit '#{name}' is registered")

  (@name = 'unknown', @description = '') ->

  # used by permit-for to extend specific permit from base class (prototype)
  use: (obj) ->
    lo.extend @, obj

  permit-matcher-class: PermitMatcher
  matcher: (access-request) ->
    new @permit-matcher-class @, access-request

  rule-applier-class: RuleApplier
  rule-applier: (access-request) ->
    new @rule-applier-class @rule-repo, @rules, access-request

  rule-repo:    new RuleRepo
  allower:      new PermitAllower @rule-repo

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @matcher(access-request).match!

  apply-static-rules: ->
    rule-applier!.apply-static-rules!

  # always called (can be overridden for custom behavior)
  apply-dynamic-rules: (access-request) ->
    rule-applier(access-request).apply-dynamic-rules!

  can-rules: ->
    @rule-repo.can-rules
  cannot-rules: ->
    @rule-repo.cannot-rules
