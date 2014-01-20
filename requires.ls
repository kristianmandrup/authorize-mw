rek = require 'rekuire'
require 'sugar'
_ = require 'prelude-ls'

underscore = (items) ->
  items = items.flatten!
  strings = items.map (item) ->
    String(item)
  _.map (.underscore!), strings


test-path = (...paths) ->
  upaths = underscore(...paths)
  ['.', 'test', upaths].flatten!.join '/'

module.exports =
  test: (...paths) ->
    require test-path(paths)

  fixture: (path) ->
    @test 'fixtures', path

  # alias
  fix: (path) ->
    @fixture path

  factory: (path) ->
    @test 'factories', path

  # alias
  fac: (path) ->
    @factory path

  file: (path) ->
    require ['.', path.underscore!].join '/'

  # m - alias for module
  m: (path) ->
    @file path

  files: (...paths) ->
    paths.map (path) ->
      @file(path)

  fixtures: (...paths) ->
    paths.map (path) ->
      @fixture(path)

  tests: (...paths) ->
    paths.map (path) ->
      @test(path)
