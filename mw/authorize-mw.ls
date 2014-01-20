rek      = require 'rekuire'
requires = rek 'requires'

_           = require 'prelude-ls'

ModelMw     = require('model-mw').mw
ModelRunner = require('model-mw').runner

Ability     = requires.file 'ability'
Debugger    = requires.file 'debugger'

# Should extend model middleware?
module.exports = class AuthorizeMw extends ModelMw implements Debugger
  # Note: context should have a runner, then data is set via model of runner! Duh!
  (context) ->
    super ...
    @current-user = @context.current-user

    unless @current-user
      throw Error "Context must have a currentUser that is being authorized, was: #{@context}"

    @ability = new Ability @current-user

  # TODO: Fix! See ModelMw
  run: (args) ->
    # fx create(args)
    @name       = args['name'] if args['name']
    @collection = args['collection'] if args['collection']
    @ctx        = args['ctx'] if args['ctx']

    set-model! # WTF!? maybe we should have such a method in model-mw or model-runner!?

    @[name] # calls get() if name == 'get' - Duh!

  # TODO: Fix! See ModelMw
  can: (action) ->
    if @ability.can(action, @collection, @ctx) then @next() else false

  # TODO: Fix this shit!
  get: ->
    can 'get one'
  create: ->
    can 'create one'
  update: ->
    can 'update one'
  delete: ->
    can 'delete one'

  getAll: ->
    can 'get many'
  updateAll: ->
    can 'update one'
  deleteAll: ->
    can 'delete one'

