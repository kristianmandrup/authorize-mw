require '../test_setup'

_             = require 'prelude-ls'
RuleApplier   = require '../../rule_applier'
RuleRepo      = require '../../rule_repo'

User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  before ->
    book          := new Book 'Far and away'

  describe 'create' ->

  # can create, edit and delete a Book
  xdescribe 'manage book' ->

  # can read any subject
  xdescribe 'read any' ->

  # can read any subject
  xdescribe 'read *' ->

  # can create, edit and delete any subject
  xdescribe 'manage any' ->

  # can create, edit and delete a Book
  xdescribe 'manage *' ->

