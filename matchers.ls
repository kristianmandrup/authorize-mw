/**
 * User: kmandrup
 * Date: 20/12/13
 * Time: 13:48
 */

Intersect = require './intersect'

_ = require 'prelude-ls'
require 'sugar'

Debugger = require './debugger'

class BaseMatcher implements Debugger
  (access-request) ->
    @set-access-request access-request
    @set-intersect!

  match: (value) ->
    false

  death-match: (name, value) ->
    return true if @[name] and value is void
    false

  set-access-request: (access-request) ->
    @access-request = if access-request then access-request else {}

  set-intersect: ->
    @intersect ||= Intersect()

class ActionMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-action!

  set-action: ->
    @action ||= if @access-request? then @access-request.action else ''

  match: (action) ->
    if _.is-type 'Function' action
      return action.call @action

    return true if @death-match 'action', action
    @action is action

class UserMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-user!

  set-user: ->
    @user ||= if @access-request? then @access-request.user else {}

  match: (user) ->
    if _.is-type 'Function' user
      return user.call @user

    return true if @death-match 'user', user
    @intersect.on user, @user

class SubjectMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-subject!

  set-subject: ->
    @subject ||= if @access-request? then @access-request.subject else {}

  match: (subject) ->
    if _.is-type 'Function' subject
      return subject.call @subject
    return true if @death-match 'subject', subject
    @intersect.on subject, @subject

  match-clazz: (subject) ->
    clazz = subject.camelize!
    return false unless @subject and @subject.constructor
    @subject.constructor.display-name is clazz

class ContextMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-ctx!

  set-ctx: ->
    @ctx ||= if @access-request? then @access-request.ctx else {}

  match: (ctx) ->
    if _.is-type 'Function' ctx
      return ctx.call @ctx

    return true if @death-match 'ctx', ctx
    @intersect.on ctx, @ctx

class AccessMatcher
  (@access-request) ->
    @match-result = true

  user-matcher: ->
    @um ||= new UserMatcher(@access-request)

  subject-matcher: ->
    @sm ||= new SubjectMatcher(@access-request)

  action-matcher: ->
    @am ||= new ActionMatcher(@access-request)

  context-matcher: ->
    @cm ||= new ContextMatcher(@access-request)

  match-on: (hash) ->
    all = hash
    for key in _.keys hash
      match-fun   = @[key]
      match-value = hash[key]

      if _.is-type 'Function' match-fun
        delete all[key]
        match-fun.call(@, match-value).match-on(all)
    @result!

  result: ->
    @match-result

  update: (result) ->
    @match-result = @match-result and result

  user: (user) ->
    @update @user-matcher!.match(user)
    @

  has-user: (user) ->
    @user(user).result!

  role: (role) ->
    @user role: role
    @

  has-role: (role) ->
    @role(role).result!

  subject: (subject) ->
    @update @subject-matcher!.match(subject)
    @

  has-subject: (subject) ->
    @subject(subject).result!

  subject-clazz: (clazz) ->
    @update @subject-matcher!.match-clazz(clazz)
    @

  has-subject-clazz: (clazz) ->
    @subject-clazz(clazz).result!

  action: (action) ->
    @update @action-matcher!.match(action)
    @

  has-action: (action) ->
    @action(action).result!

  context: (ctx) ->
    @update @context-matcher!.match(ctx)
    @

  ctx: (ctx) ->
    @context ctx

  has-context: (context) ->
    @context(context).result!

  has-ctx: (context) ->
    @ctx(context).result!


  has: (name, value) ->
    @[name](value).result!


module.exports =
  BaseMatcher     : BaseMatcher
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher
  AccessMatcher   : AccessMatcher