/**
 * User: kmandrup
 * Date: 20/12/13
 */
require '../test_setup'

_             = require 'prelude-ls'
User          = require '../fixtures/user'
Book          = require '../fixtures/book'

PermitMatcher   = require '../../permit_matcher'
match-makers    = require '../../permit_match_maker'

Intersect       = require '../../intersect'

MatchMaker      = match-makers.MatchMaker

describe 'MatchMaker' ->
  var matcher
  var access-request

  before ->
    access-request := {}

  describe 'create' ->
    context 'no access request' ->
      before ->
        matcher  := new MatchMaker

      specify 'must have access request' ->
        matcher.access-request.should.eql {}

    context 'empty access request' ->
      before ->
        matcher        := new MatchMaker access-request

      specify 'must be a user matcher' ->
        matcher.should.be.an.instance-of MatchMaker

      specify 'must have access request' ->
        matcher.access-request.should.eql access-request

      specify 'must have an intersect' ->
        matcher.intersect.should.have.property 'on'

UserMatcher   = match-makers.UserMatcher

describe 'UserMatcher' ->
  var user-matcher
  var admin-access-request
  var admin-user

  before ->
    admin-user := new User name: 'kris' role: 'admin'
    admin-access-request :=
      user: admin-user

  describe 'create' ->
    before ->
      user-matcher  := new UserMatcher admin-access-request

    specify 'must be a user matcher' ->
      user-matcher.should.be.an.instance-of UserMatcher

    specify 'must have admin access request' ->
      user-matcher.access-request.should.eql admin-access-request

  describe 'match' ->
    before-each ->
      user-matcher  := new UserMatcher admin-access-request

    specify 'should match admin role' ->
      user-matcher.match(role : 'admin').should.be.true

    specify 'should NOT match guest role' ->
      user-matcher.match(role: 'guest').should.be.false

    specify 'should match on no argument' ->
      user-matcher.match!.should.be.true

ActionMatcher = match-makers.ActionMatcher

describe 'ActionMatcher' ->
  var action-matcher

  var read-access-request

  before ->
    read-access-request :=
      action: 'read'

  describe 'create' ->
    before-each ->
      action-matcher  := new ActionMatcher read-access-request

    specify 'must have admin access request' ->
      action-matcher.access-request.should.eql read-access-request

  describe 'match' ->
    before-each ->
      action-matcher  := new ActionMatcher read-access-request

    specify 'should match read action' ->
      action-matcher.match('read').should.be.true

    specify 'should NOT match write action' ->
      action-matcher.match('write').should.be.false

    specify 'should match on no argument' ->
      action-matcher.match!.should.be.true

SubjectMatcher = match-makers.SubjectMatcher

describe 'SubjectMatcher' ->
  var subject-matcher
  var book-access-request
  var book, book-title

  before ->
    book-title := 'the return of the jedi'
    book := new Book title: book-title
    book-access-request :=
      subject: book

  describe 'create' ->
    before-each ->
      subject-matcher  := new SubjectMatcher book-access-request

    specify 'must have admin access request' ->
      subject-matcher.access-request.should.eql book-access-request

  describe 'match' ->
    before-each ->
      subject-matcher  := new SubjectMatcher book-access-request

    specify 'should match book: the return of the jedi' ->
      subject-matcher.match(title: book-title).should.be.true

    specify 'should NOT match book: the return to oz' ->
      subject-matcher.match(title: 'the return to oz').should.be.false

    specify 'should match on no argument' ->
      subject-matcher.match!.should.be.true

ContextMatcher = match-makers.ContextMatcher

describe 'ContextMatcher' ->
  var ctx-matcher
  var visitor-access-request
  var area-ctx

  before ->
    area-ctx := {area: 'visitor' }
    visitor-access-request := {ctx: area-ctx }

  describe 'create' ->
    before-each ->
      ctx-matcher  := new ContextMatcher visitor-access-request

    specify 'must have admin access request' ->
      ctx-matcher.access-request.should.eql visitor-access-request

  describe 'match' ->
    before-each ->
      ctx-matcher  := new ContextMatcher visitor-access-request

    specify 'should match area: visitor' ->
      ctx-matcher.match(area-ctx).should.be.true

    specify 'should NOT match area: member' ->
      ctx-matcher.match(area: 'member').should.be.false

    specify 'should match on no argument' ->
      ctx-matcher.match!.should.be.true
