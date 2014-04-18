// Generated by LiveScript 1.2.0
(function(){
  var requires, ability, matchers, ActionMatcher;
  requires = require('../../../requires');
  requires.test('test_setup');
  ability = require('./abilities');
  matchers = requires.lib('matchers');
  ActionMatcher = matchers.ActionMatcher;
  describe('ActionMatcher', function(){
    var actionMatcher, requests;
    requests = {};
    before(function(){
      return requests.read = {
        action: 'read'
      };
    });
    describe('create', function(){
      beforeEach(function(){
        return actionMatcher = new ActionMatcher(requests.read);
      });
      return specify('must have admin access request', function(){
        return actionMatcher.accessRequest.should.eql(requests.read);
      });
    });
    return describe('match', function(){
      beforeEach(function(){
        return actionMatcher = new ActionMatcher(requests.read);
      });
      specify('should match read action', function(){
        return actionMatcher.match('read').should.be['true'];
      });
      specify('should NOT match write action', function(){
        return actionMatcher.match('write').should.be['false'];
      });
      return specify('should match on no argument', function(){
        return actionMatcher.match().should.be['true'];
      });
    });
  });
}).call(this);