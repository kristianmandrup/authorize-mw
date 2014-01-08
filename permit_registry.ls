_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Permit    = require './permit'
Debugger  = require './debugger'

todo = "allow creation of multiple registries and select one to use per environment"

class PermitRegistry implements Debugger
  # constructor
  ->
    throw Error "PermitRegistry is currently a singleton (TODO: #{todo})"

  # class methods/variables (singleton)
  @permits = []
  @permit-counter = 0

  @calc-name = (name) ->
    if name is undefined
      name = "Permit-#{@@permit-counter}"

    unless _.is-type 'String', name
      throw Error "Name of permit must be a String, was: #{name}"
    name

  @register-permit = (permit) ->
    permit.name = @calc-name permit.name
    name = permit.name

    if @@permits[name]
      throw Error "A Permit named: #{name} is already registered, please use a different name!"

    # register permit in Permit.permit
    @@permits[name] = permit
    @@permit-counter = @@permit-counter+1

  @clear-permits = ->
    @@permits = []

  @clear-all = ->
    @@clear-permits!

  @clean-permits = ->
    for permit in @@permits
      permit.clear!

  @clean-all = ->
    @@clean-permits!

module.exports = PermitRegistry