require 'sugar'

_         = require 'prelude-ls'
Util      = require './util'
Intersect = require './intersect'

module.exports = class PermitMatcher
  (@permit) ->
    @intersect = Intersect()

  match: (access) ->
    # use object intersection test if permit has includes or excludes
    throw Error "PermitMatcher missing permit" unless @permit
    unless access? and not _.is-type 'Unknown' access
      throw Error "Access is undefined"

    console.log "access", access
    matchInclude = true
    if _.is-type 'Function' @permit.match
      matchInclude = @permit.match access

    matchExclude = false
    if _.is-type 'Function' @permit.ex-match
      matchExclude = @permit.ex-match access

    # call function if function, otherwise use static value
    res = {}
    res.include = @intersectOn @permit.includes, access
    res.exclude = @intersectOn @permit.excludes, access
    (res.include or matchInclude) and not (res.exclude or matchExclude)

  intersectOn: (item, access) ->
    return false unless item?
    return false if _.is-type 'Unknown' item

    if _.is-type 'Function' item
      item = item!
    @intersect.on item, access
