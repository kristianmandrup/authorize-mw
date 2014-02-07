rek      = require 'rekuire'
requires = rek 'requires'

Debugger      = requires.file 'debugger'

AccessRequest = requires.file './access_request'
Ability       = requires.file './ability'

module.exports = class Authorizer implements Debugger
  (@user) ->

  # can user do action on object in context
  run: (action, subject, context) ->
    @debug 'run', action, subject, context
    @can action, subject, context

  create-ability: ->
    a = new Ability(@user)
    a.debug-on! if @debugging
    a

  ability: ->
    @current-ability ||= @create-ability!

  access: (action, subject, ctx) ->
    new AccessRequest @user, action, subject, ctx

  # note that object can be a class or instance
  authorize: (action, subject, context) ->
    @debug 'authorize', action, subject, context
    @ability!.authorize @access(action, subject, context)

  can: (action, subject, context) ->
    @debug 'can', action, subject, context
    @ability!.can @access(action, subject, context)

  cannot: (action, subject, context) ->
    @debug 'cannot', action, subject, context
    @ability!.cannot @access(action, subject, context)