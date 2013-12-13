# do similar for validation!

_           = require 'prelude-ls'
Middleware  = require 'middleware'
Ability     = require '../ability'

authorization = class Authorization extends Middleware 
  (context) ->
    @context = context
    @current-user = @context.current-user
    @ability = new Ability @current-user

  run: (args) ->
    # fx create(args)
    @name = args['name']
    @collection = args['collection']
    @ctx = args['ctx']
    set-model!

    @[name]
  
  can: (action) ->
    if @ability.can(action, @collection, @ctx) then @next() else false

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

