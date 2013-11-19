_ = require 'lodash'
Mixin = require './mixin'
require 'sugar'

Intersect = require './intersect'
Util = require './util'

module.exports = class Permit extends Mixin
  @permits = []

  constructor: (@name) ->
    @intersect = Intersect()
    @canRules = []
    @cannotRules = []

  matches: (access) ->
    # use object intersection test if permit has includes or excludes
    matchInclude = true
    if @match? && @match typeof Function
      matchInclude = @match access

    matchExclude = false
    if @exMatch? && @exMatch typeof Function
      matchExclude = @exMatch access

    # call function if function, otherwise use static value
    res = {}
    res.include = @intersectOn @includes
    res.exclude = @intersectOn @excludes
    (res.include or matchInclude) and not (res.exclude or matchExclude)

  intersectOn: (item) ->
    if item?
      return @intersect.on access, item() if item typeof Function
      @intersect.on access, item

  allows: (rule) ->
    return false if @disallows(rule)
    @canRules.include rule
  
  disallows: (rule) -> 
    @cannotRules.include rule

class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  constructor: ->
    super

  match: (access) ->
    true

access = 
  user:
    role: 'admin'
 
admPermit   = new AdminPermit
guestPermit = new GuestPermit

console.log admPermit.matches access
console.log guestPermit.matches access
 
