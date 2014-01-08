class Debugger
  @debug = (msg) ->
    if @@debuging
      console.log msg

  @debug-on = ->
    @@debuging = true

  @debug-off = ->
    @@debuging = false

module.exports = Debugger