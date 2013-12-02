require 'sugar'

_         = require 'prelude-ls'
Util      = require './util'
Intersect = require './intersect'

module.exports = class PermitMatcher
  (@permit) ->
    @intersect = Intersect()

  match: (access) ->
    # use object intersection test if permit has includes or excludes
    return false unless @permit

    matchInclude = true
    unless _.is-type 'Undefined' @permit.match
      if _.is-type 'Function' @permit.match
        matchInclude = @permit.match access

    matchExclude = false
    unless _.is-type 'Undefined' @permit.ex-match
      if _.is-type 'Function' @permit.ex-match
        matchExclude = @permit.ex-match access

    # call function if function, otherwise use static value
    res = {}
    res.include = @intersectOn @permit.includes
    res.exclude = @intersectOn @permit.excludes
    (res.include or matchInclude) and not (res.exclude or matchExclude)

  intersectOn: (item) ->
    if item?
      return @intersect.on access, item() if item typeof Function
      @intersect.on access, item
