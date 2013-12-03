# VERY experimental pseudo code mostly
# See authorize-mw for real middleware code!

# The following are mainly some ideas for integration with Angular.js and Racer.js

racer = require 'racer'

RacerModel = ->
  base =
    ids: ->
      racer.get(@collection).map (item) ->
        item._id

    error: (msg, args) ->
      new Error(msg, args)

  # ids is optional array of ids, if empty, do for all
  getAll: (model, ids) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'getAll', model: model, ->
          racer.get(@collection)
        )

  get: (model, id) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'getAll', model: model, ->
          racer.get(@collection + '.' + id);
        )

  getOwn: (model, id) ->
    self = @
    _.extend {}, base,
      exec: ->
        obj = self.get(model, id).exec()
        if (obj.user && obj.user.id == @currentUser.id)
          obj
        else
          @error 'You are not the owner of', model, id

  create: (model, data) ->
    self = @
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'create', model: model, ->
          # , data
          racer.add(self.collection, data);
        )

  update: (model, id, data) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'update one', model: model, ->
          racer.set(@collection + '.' + id, data);
        )
    # ids is optional array of ids, if empty, do for all

  updateAll: (model, ids, data) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'update many', model: model, ->
          if ids.empty? then @updateList(@ids, @data) else @updateList(ids, data)
        )

  updateList: (ids, data) ->
    for id in ids
      racer.set(@collection + '.' + id, data);

  delete: (model, id) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'delete one', model: model, ->
          racer.delete(@collection + '.' + id);
        )
  # ids is optional array of ids, if empty, do for all
  deleteAll: (model, ids) ->
    _.extend {}, base,
      exec: ->
        mwRunner(action: 'delete many', model: model, ->
          if ids.empty? then deleteAll() else deleteList(ids)
        )