# _ = require 'prelude-ls'
# require 'sugar'

normalize = require './normalize'

module.exports = class AccessRequest
  # factory method
  @from  = (obj) ->
    new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx)

  # constructor
  (@user, @action, @subject, @ctx) ->
    @normalize

  # normalize action and subject if they are not each a String
  normalize: ->
    @action = normalize @action
    @subject = normalize @subject

