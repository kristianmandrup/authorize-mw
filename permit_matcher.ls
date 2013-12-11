require 'sugar'

_         = require 'prelude-ls'
Util      = require './util'
Intersect = require './intersect'

# The matcher is used to determine if the Permit should apply at all in the given access context
# Given an access-request, it should check the permit via:
#   permit.match
#   permit.ex-match

# It should also check the permit.includes and permit.excludes
# which may contain objects used to test intersection on the access-request
# if any of all these gives a positive match, the permit should be used for the access-request
# otherwise the permit will be ignored
module.exports = class PermitMatcher
  (@permit, @access-request) ->
    @intersect = Intersect()
    @validate!

  match: ->
    # includes and excludes can contain a partial (object) used to do intersection test on access-request
    (@include! or @custom-match!) and not (@exclude! or @custom-exmatch!)

  include: ->
    @intersect-on @permit.includes

  exclude: ->
    @intersect-on @permit.excludes

  custom-exmatch: ->
    if _.is-type 'Function' @permit.ex-match
      return @permit.ex-match @access-request
    false

  custom-match: ->
    if _.is-type 'Function' @permit.match
      return @permit.match @access-request
    false

  intersect-on: (partial) ->
    console.log "partial", partial
    return false unless partial?

    if _.is-type 'Function' partial
      partial = partial!
    console.log "intersect", @intersect
    res = @intersect.on partial, @access-request
    console.log "res", res
    res

  validate: ->
    # use object intersection test if permit has includes or excludes
    throw Error "PermitMatcher missing permit" unless @permit
    if @access-request? and _.is-type 'Unknown' @access-request
      throw Error "access-request is undefined"
