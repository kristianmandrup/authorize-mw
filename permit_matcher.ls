require 'sugar'

_         = require 'prelude-ls'
Util      = require './util'
Intersect = require './intersect'

module.exports = class PermitMatcher
  (@permit) ->
    @intersect = Intersect()

  match: (access) ->
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
