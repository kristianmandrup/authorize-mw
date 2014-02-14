requires  = require '../../requires'
_         = require 'prelude-ls'
lo        = require 'lodash'
require 'sugar'

Debugger  = requires.lib 'debugger'

todo = "allow creation of multiple registries and select one to use per environment"

module.exports = class PermitRegistry implements Debugger
  # constructor
  ->
    throw Error "PermitRegistry is currently a singleton (TODO: #{todo})"

  # class methods/variables (singleton)
  @permits = {}
  @permit-counter = 0

  @calc-name = (name) ->
    if name is undefined
      name = "Permit-#{@@permit-counter}"

    unless _.is-type 'String', name
      throw Error "Name of permit must be a String, was: #{name}"
    name

  @get = (name) ->
    @@permits[name] || throw Error("No permit '#{name}' is registered")

  @register-permit = (permit) ->
    permit.name = @calc-name permit.name
    name = permit.name

    unless _.is-type 'Object', @@permits
      throw Error "permits registry container must be an Object in order to store permits by name, was: #{@@permits}"

    if @@permits[name]
      throw Error "A Permit named: #{name} is already registered, please use a different name!"

    # register permit in Permit.permit
    @@permits[name] = permit
    @@permit-counter = @@permit-counter+1

  @clear-permits = ->
    @@permits = {}
    @@permit-counter = 0

  @clear-all = ->
    @@clear-permits!

  @clean-permits = ->
    for permit in @@permits
      permit.clean!

  @clean-all = ->
    @@clean-permits!


lo.extend PermitRegistry, Debugger