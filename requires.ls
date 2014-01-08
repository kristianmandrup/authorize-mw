require 'sugar'
_ = require 'prelude-ls'

underscore = (items) ->
  strings = items.map (item) ->
    String(item)
  _.map (.underscore!), strings

test-level = 2
file-level = 1

base-path = ->
  @bp ||= (['..'] * test-level).join '/'

file-base-path = ->
  @fbp ||= (['..'] * file-level).join '/'

test-path = (...paths) ->
  upaths = underscore(...paths)
  [base-path!, upaths].flatten!.join '/'

module.exports =
  file-lv: (lvs) ->
    file-level := lvs

  test-lv: (lvs) ->
    test-level := lvs

  test: (...paths) ->
    require test-path(paths)

  fixture: (path) ->
    @test 'fixtures', path

  # alias
  fix: (path) ->
    @fixture path

  file: (path) ->
    @test file-base-path!, path

  # m - alias for module
  m: (path) ->
    @file path
