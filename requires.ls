rek = require 'rekuire'
require 'sugar'
_ = require 'prelude-ls'

underscore = (items) ->
  strings = items.map (item) ->
    String(item)
  _.map (.underscore!), strings

test-level = 1
file-level = 0

test-base-path = ->
  "test"
  # @bp ||= (['..'] * test-level).join '/'

file-base-path = ->
  "."
  # @fbp ||= (['..'] * file-level).join '/'

test-path = (...paths) ->
  upaths = underscore(...paths)
  [test-base-path!, upaths].flatten!.join '/'

module.exports =
  file-lv: (lvs) ->
    file-level := lvs

  test-lv: (lvs) ->
    test-level := lvs

  test: (...paths) ->
    rek test-path(paths)

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
    rek [file-base-path!, path.underscore!].join '/'

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
