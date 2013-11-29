# do similar for validation!
authorization = (context) ->
  @context = context

  currentUser: @context['currentUser']
  run: (args) ->
    # fx create(args)
    @name = args['name']
    @collection = args['collection']

    @[name](collection)
  can: (action) ->
    if currentUser.can(action, collection) then next() else false

  get: (collection) ->
    can 'get one', collection
  create: (collection) ->
    can 'create one', collection
  update: (collection) ->
    can 'update one', collection
  delete: (collection) ->
    can 'delete one', collection

  getAll: (collection) ->
    can 'get many', collection
  updateAll: (collection) ->
    can 'update one', collection
  deleteAll: (collection) ->
    can 'delete one', collection

