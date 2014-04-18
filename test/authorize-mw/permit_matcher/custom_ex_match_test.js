// Generated by LiveScript 1.2.0
(function(){
  var requires, setup, Book, User, Permit, permitFor, PermitMatcher, PermitRegistry, createUser, createRequest, createPermit;
  requires = require('../../../requires');
  requires.test('test_setup');
  setup = require('./permits').setup;
  Book = requires.fix('user');
  User = requires.fix('book');
  Permit = requires.lib('permit');
  permitFor = requires.permit('permit-for');
  PermitMatcher = requires.permit('permit_matcher');
  PermitRegistry = requires.permit('permit-registry');
  createUser = requires.fac('create-user');
  createRequest = requires.fac('create-request');
  createPermit = requires.fac('create-permit');
  describe('PermitMatcher', function(){
    var subject, permitMatcher, book, users, permits, requests, matching, noneMatching;
    users = {};
    permits = {};
    requests = {};
    matching = {};
    noneMatching = {};
    return describe('custom-ex-match', function(){
      before(function(){
        PermitRegistry.clearAll();
        requests.admin = {
          user: {
            role: 'admin'
          }
        };
        requests.ctx = {
          ctx: void 8
        };
        permits.exUser = setup.exUserPermit();
        matching.permitMatcher = new PermitMatcher(permits.exUser, requests.admin);
        return noneMatching.permitMatcher = new PermitMatcher(permits.exUser, requests.ctx);
      });
      specify('matches access-request using permit.ex-match', function(){
        return matching.permitMatcher.customExMatch().should.be['true'];
      });
      specify('does NOT match access-request since permit.match does NOT match', function(){
        return noneMatching.permitMatcher.customExMatch().should.be['false'];
      });
      return describe('invalid ex-match method', function(){
        before(function(){
          return permits.invalidExUser = setup.invalidExUser();
        });
        return specify('should throw error', function(){
          return function(){
            return noneMatching.permitMatcher.customExMatch;
          }.should['throw'];
        });
      });
    });
  });
}).call(this);
