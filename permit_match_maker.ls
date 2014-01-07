/**
 * User: kmandrup
 * Date: 20/12/13
 * Time: 13:48
 */

Intersect = require './intersect'

class MatchMaker
  (@access-request) ->
    @set-intersect!

  match: (action) ->
    false

  set-intersect: ->
    @intersect ||= Intersect()

class ActionMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-action!

  set-action: ->
    @action ||= if @access-request? then @access-request.action else ''

  match: (action) ->
    @action is action

class UserMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-user!

  set-user: ->
    @user ||= if @access-request? then @access-request.user else {}

  match: (user) ->
    @intersect.on user, @user

class SubjectMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-subject!

  set-subject: ->
    @subject ||= if @access-request? then @access-request.user else {}

  match: (subject) ->
    @intersect.on subject, @subject

class ContextMatcher extends MatchMaker
  (@access-request) ->
    super ...
    @set-ctx!

  set-ctx: ->
    @ctx ||= if @access-request? then @access-request.ctx else {}

  match: (ctx) ->
    @intersect.on ctx, @ctx

module.exports =
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher