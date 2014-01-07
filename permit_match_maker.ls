/**
 * User: kmandrup
 * Date: 20/12/13
 * Time: 13:48
 */

Intersect = require './intersect'

class MatchMaker
  (access-request) ->
    @set-access-request access-request
    @set-intersect!

  match: (action) ->
    return true if action is {} or action is undefined
    false

  set-access-request: (access-request) ->
    @access-request = if access-request then access-request else {}

  set-intersect: ->
    @intersect ||= Intersect()

class ActionMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-action!

  set-action: ->
    @action ||= if @access-request? then @access-request.action else ''

  match: (action) ->
    return true if super action
    @action is action

class UserMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-user!

  set-user: ->
    @user ||= if @access-request? then @access-request.user else {}

  match: (user) ->
    return true if super user
    @intersect.on user, @user

class SubjectMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-subject!

  set-subject: ->
    @subject ||= if @access-request? then @access-request.subject else {}

  match: (subject) ->
    return true if super subject
    @intersect.on subject, @subject

class ContextMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-ctx!

  set-ctx: ->
    @ctx ||= if @access-request? then @access-request.ctx else {}

  match: (ctx) ->
    return true if super ctx
    @intersect.on ctx, @ctx

module.exports =
  MatchMaker      : MatchMaker
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher