_ = require 'prelude-ls'

module.exports = class User
  (@user) ->
    for key in _.keys(@user)
      @[key] = @user[key]
