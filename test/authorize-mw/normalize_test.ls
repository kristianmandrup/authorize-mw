require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
normalize = require './normalize'

describe 'normalize' ->
  var user

  before ->
    fun = ->
      ["xyz"]
    str = "abc"
    list = ['a', 'b']

    nested-fun = ->
      ["abc", fun]

  describe 'Function' ->
    specify 'is called' ->
      normalize(fun).should.eql ["xyz"]

  describe 'String' ->
    specify 'wrapped in array' ->
      normalize(str).should.eql [str]

  describe 'Array' ->
    specify 'returned' ->
      normalize(list).should.eql list

  describe 'Number' ->
    specify 'throws error' ->
      # normalize(3).should

  describe 'Nested Functions' ->
    specify 'normalized to single array' ->
      normalize(list).should.eql ["abc", "xyz"]
