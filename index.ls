rek      = require 'rekuire'
requires = rek 'requires'

module.exports =
  authorize-mw: requires.file 'mw/authorize-mw'
  authorizer:   requires.file 'authorizer'