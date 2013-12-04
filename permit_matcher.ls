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
  (@permit) ->
    @intersect = Intersect()

  match: (access-request) ->
    # use object intersection test if permit has includes or excludes
    throw Error "PermitMatcher missing permit" unless @permit
    unless access? and not _.is-type 'Unknown' access
      throw Error "Access is undefined"

    console.log "access", access-request
    match-include = true
    if _.is-type 'Function' @permit.match
      match-include = @permit.match access-request

    match-exclude = false
    if _.is-type 'Function' @permit.ex-match
      match-exclude = @permit.ex-match access-request

    # call function if function, otherwise use static value
    res = {}

    # includes and excludes can contain a partial (object) used to do intersection test on access-request
    res.include = @intersect-on @permit.includes, access-request
    res.exclude = @intersect-on @permit.excludes, access-request

    (res.include or match-include) and not (res.exclude or match-exclude)

  intersect-on: (partial, access-request) ->
    return false unless partial?
    return false if _.is-type 'Unknown' item

    if _.is-type 'Function' partial
      partial = partial!
    @intersect.on partial, access
