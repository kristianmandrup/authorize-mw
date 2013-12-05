AccessRequest = require './access_request'

module.exports = class Authorizer
  (@user) ->

  # can user do action on object in context
  run: (action, subject, context) ->
    @can action, subject, context

  ability: ->
    @current-ability ||= new Ability(@user)

  access: (action, subject, ctx) ->
    new AccessRequest action, subject, ctx

  # note that object can be a class or instance
  authorize: (action, subject, context) ->
    @ability!.authorize @access(action, subject, context)

  can: (action, subject, context) ->
    @ability!.can @access(action, subject, context)

  cannot: (action, subject, context) ->
    @ability!.cannot @access(action, subject, context)