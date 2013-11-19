type = require './type'
Permit = require './permit'

module.exports = permitFor = (name, baseObj) ->
  permit = new Permit(name)
  if baseObj? && type(baseObj) is 'function'
    baseObj = baseObj()

  permit = permit.use baseObj
  Permit.permits.push permit
  permit
