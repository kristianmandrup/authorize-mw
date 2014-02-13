requires  = require './requires'

module.exports =
  authorize-mw: requires.mw 'authorize-mw'
  authorizer:   requires.lib 'authorizer'