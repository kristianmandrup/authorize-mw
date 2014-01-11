lo = require 'lodash'

module.exports =
  debugging: false

  debug: (msg) ->
    console.log ...if @debugging

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false
