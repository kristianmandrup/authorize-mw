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

  matcher: (access-request) ->
    new PermitMatcher @, access-request

  rule-applier: new RuleApplier @rule-repo, @rules
  rule-repo:    new RuleRepo
  allower:      new PermitAllower @rule-repo

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @matcher(access-request).match!

  can-rules: ->
    @rule-repo.can-rules
  cannot-rules: ->
    @rule-repo.cannot-rules
