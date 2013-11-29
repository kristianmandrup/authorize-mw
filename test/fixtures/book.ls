module.exports = class Book
  (@obj) ->
    for key in _.keys(@obj)
      @[key] = @obj[key]
