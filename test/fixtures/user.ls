_ = require 'prelude-ls'

class User
  (user) ->
    @set user

  set: (user)->
    for key in _.keys(user)
      @[key] = user[key]

module.exports = User