module.exports = class User
  (@obj) ->
    for key in _.keys(@obj)
      @[key] = @obj[key]
