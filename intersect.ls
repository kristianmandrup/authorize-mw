_ = require 'lodash'

# TODO: Needs Testing!!!
# Not yet completely working - needs match on all keys (complete intersection, not just one/first match
module.exports = ->
  countProps = (obj) ->
    count = 0
    for k in obj
      count++ if (obj.hasOwnProperty(k))
    count;

  objectEquals = (v1, v2) ->
    return false if typeof(v1) is not typeof(v2)
    if v1 instanceof Object && v2 instanceof Object
      return false if countProps(v1) isnt countProps(v2)
      r = true
      for k in v1
        r = objectEquals v1[k], v2[k]
        return false if not r
      return true;
    else
      return v1 is v2;

  recursivePartialEqual = (partial, obj) ->
    res = false
    for key of partial
      a = partial[key]
      b = obj[key]
      continue if a is 'undefined'

      if a instanceof Object && b instanceof Object
        recursivePartialEqual a, b if b
      else
        res = true if objectEquals a, b
    res

  on: (a, b) ->
    recursivePartialEqual a, b
