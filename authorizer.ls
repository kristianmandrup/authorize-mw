module.exports = class Authorizer
  (user) ->
    @user = user

  # can user do action on object in context
  run: (action, object, context) ->
    @can(action, object, context)

  ability: ->
    @currentAbility ||= new Ability(@user)

  access: (action, obj, ctx) ->
    {action: action, obj: obj, ctx: context}

  # note that object can be a class or instance
  authorize: (action, obj, context) ->
    @ability().authorize @access(action, obj, context)

  can: (action, obj, context) ->
    @ability().can @access(action, obj, context)

  cannot: (action, obj, context) ->
    @ability().cannot @access(action, obj, context)