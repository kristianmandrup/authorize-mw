// Generated by LiveScript 1.2.0
(function(){
  var requires, _, User, Book, RuleRepo, PermitAllower;
  requires = require('../../requires');
  requires.test('test_setup');
  _ = require('prelude-ls');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleRepo = requires.rule('rule_repo');
  PermitAllower = requires.permit('permit_allower');
  describe('PermitAllower', function(){
    var ruleRepo, permitAllower, book, defUser, userRequest, bookRequest;
    defUser = new User({
      role: 'guest'
    });
    userRequest = function(action, subject){
      return {
        user: defUser,
        action: action,
        subject: subject
      };
    };
    bookRequest = function(action){
      return userRequest(action, 'book');
    };
    before(function(){
      ruleRepo = new RuleRepo;
      book = new Book('Far and away');
      return permitAllower = new PermitAllower(ruleRepo);
    });
    context('test helpers', function(){
      describe('user-request', function(){
        specify('has default user ', function(){
          return userRequest('read', 'paper').user.should.eql(defUser);
        });
        specify('has subject book', function(){
          return userRequest('read', 'paper').subject.should.eql('paper');
        });
        return specify('has action read', function(){
          return userRequest('read', 'paper').action.should.eql('read');
        });
      });
      return describe('book-request', function(){
        specify('has subject book', function(){
          return bookRequest('read').subject.should.eql('book');
        });
        return specify('has action read', function(){
          return bookRequest('read').action.should.eql('read');
        });
      });
    });
    describe('init', function(){
      specify('has a rule repo', function(){
        return permitAllower.should.have.a.property('ruleRepo');
      });
      return specify('rule repo is a RuleRepo', function(){
        return permitAllower.ruleRepo.constructor.should.be.eql(RuleRepo);
      });
    });
    describe('test-access', function(){
      var readBookRule, publishBookRule, lcPublishBookRule;
      before(function(){
        readBookRule = {
          action: 'read',
          subject: 'Book'
        };
        publishBookRule = {
          action: 'publish',
          subject: 'Book'
        };
        return lcPublishBookRule = {
          action: 'publish',
          subject: 'book'
        };
      });
      context('can read book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('can', 'read', 'Book');
        });
        return specify('finds match for can read/Book', function(){
          return permitAllower.testAccess('can', readBookRule).should.be['true'];
        });
      });
      return context('can publish book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('can', 'publish', 'Book');
        });
        specify('does NOT find match for can read/Book', function(){
          return permitAllower.testAccess('can', readBookRule).should.be['false'];
        });
        specify('finds match for can publish/Book', function(){
          return permitAllower.testAccess('can', publishBookRule).should.be['true'];
        });
        return specify('finds match for can publish/book', function(){
          return permitAllower.testAccess('can', lcPublishBookRule).should.be['true'];
        });
      });
    });
    describe('allows', function(){
      var readBookRequest, publishBookRequest;
      beforeEach(function(){
        readBookRequest = bookRequest('read');
        return publishBookRequest = bookRequest('publish');
      });
      context('can read book', function(){
        before(function(){
          return ruleRepo.registerRule('can', 'read', 'Book');
        });
        return specify('should allow guest user to read a book', function(){
          return permitAllower.allows(readBookRequest).should.be['true'];
        });
      });
      return context('cannot publish book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('cannot', 'publish', 'Book');
        });
        return specify('does NOT allow guest user to publish a book', function(){
          return permitAllower.allows(publishBookRequest).should.be['false'];
        });
      });
    });
    return describe('disallows', function(){
      var readBookRequest, publishBookRequest;
      before(function(){
        readBookRequest = bookRequest('read');
        return publishBookRequest = bookRequest('publish');
      });
      context('cannot publish book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('cannot', 'publish', 'Book');
        });
        return specify('should disallow guest user from publishing a book', function(){
          return permitAllower.disallows(publishBookRequest).should.be['true'];
        });
      });
      context('can read book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('can', 'read', 'Book');
        });
        return specify('does NOT disallow guest user from reading a book', function(){
          return permitAllower.disallows(readBookRequest).should.be['false'];
        });
      });
      return context('cannot read book', function(){
        beforeEach(function(){
          ruleRepo.clear();
          return ruleRepo.registerRule('cannot', 'read', 'Book');
        });
        return specify('should disallow guest user from reading a book', function(){
          return permitAllower.disallows(readBookRequest).should.be['true'];
        });
      });
    });
  });
}).call(this);
