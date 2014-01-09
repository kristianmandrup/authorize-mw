class Debugger
  debug: (...msg) ->
    console.log msg if @debugging

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false

  # class-lv debugging

  @debug = (...msg) ->
    console.log msg if @@debugging

  @debug-on = ->
    @@debugging = true

  @debug-off = ->
    @@debugging = false

module.exports = Debugger