module.exports =
  debugging: false

  debug: (msg) ->
    if @debugging
      constr = @constructor.display-name || @display-name
      console.log constr + ':'
      console.log ...

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false
