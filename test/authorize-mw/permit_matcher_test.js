// Generated by LiveScript 1.2.0
(function(){
  var requires, _, Book, User, permitFor, PermitMatcher, Permit, setup, createUser, createRequest, createPermit;
  requires = require('../../requires');
  requires.test('test_setup');
  _ = require('prelude-ls');
  Book = requires.fix('book');
  User = requires.fix('user');
  permitFor = requires.permit('permit_for');
  PermitMatcher = requires.permit('permit_matcher');
  Permit = requires.lib('permit');
  setup = require('./permit_matcher/permits').setup;
  createUser = requires.fac('create-user');
  createRequest = requires.fac('create-request');
  createPermit = requires.fac('create-permit');
  describe('PermitMatcher', function(){
    var permitMatcher, book, users, permits, requests, matching, noneMatching;
    users = {};
    permits = {};
    requests = {};
    matching = {};
    noneMatching = {};
    before(function(){
      users.kris = createUser.kris;
      users.emily = createUser.emily;
      requests.ctx = {
        ctx: {
          area: 'guest'
        }
      };
      requests.user = {
        user: users.kris
      };
      permits.user = setup.userPermit;
      return permitMatcher = new PermitMatcher(permits.user, requests.user);
    });
    describe('init', function(){
      specify('has user-permit', function(){
        return permitMatcher.permit.should.eql(permits.user);
      });
      return specify('has own intersect object', function(){
        return permitMatcher.intersect.should.have.property('on');
      });
    });
    return describe('intersect-on partial, access-request', function(){
      return specify('intersects when same object', function(){
        return permitMatcher.intersectOn(requests.user).should.be['true'];
      });
    });
  });
}).call(this);
