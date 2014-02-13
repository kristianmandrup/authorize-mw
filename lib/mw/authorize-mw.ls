rek      = require 'rekuire'
requires = rek 'requires'

_           = require 'prelude-ls'

ModelMw     = require('model-mw').mw
ModelRunner = require('model-mw').runner

Ability     = requires.file 'ability'
Authorizer  = requires.file 'authorizer'
Debugger    = requires.file 'debugger'

# Should extend model middleware?
module.exports = class AuthorizeMw extends ModelMw implements Debugger
  # Note: context should have a runner, then data is set via model of runner! Duh!
  (context) ->
    super ...

    unless _.is-type 'Object', @context
      throw Error "AuthorizeMw construction requires Object, was: #{@context}"

    unless @context.current-user
      throw Error "AuthorizeMw construction requires Object with a current-user, was: #{@context}"

    @current-user = @context.current-user

    unless @current-user
      throw Error "No currentUser to be authorized"

  # let ModelMw take care of setting args
  # Must have action: 'read' or similar to signify action being attempted
  run: (args) ->
    @debug 'run', args
    super ...
    @authorizer!.run args.action, @subject!, @ctx

  run-alone: (ctx) ->
    @debug 'run-alone', ctx
    super ...

  clear: ->
    @my-authorizer = void

  authorizer: ->
    @my-authorizer ||= @create-authorizer!

  create-authorizer: ->
    a = new Authorizer @current-user
    a.debug-on! if @debugging
    a

  subject: ->
    @data || @model