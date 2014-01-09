# TODO
requires = require('rekuire') 'requires'

requires.test 'test_setup'

_             = require 'prelude-ls'

Debugger       = requires.file 'debugger'

class TestDebug implements Debugger
  @clazz-meth = ->
    @debug "clazz-meth", "called"

  inst-meth: ->
    @debug "inst-meth", "called"

describe 'Debugger' ->
  before ->


  xdescribe 'class level' ->

  xdescribe 'instance level' ->