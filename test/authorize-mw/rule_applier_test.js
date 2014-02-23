// Generated by LiveScript 1.2.0
(function(){
  var requires, _, User, Book, RuleApplier, RuleRepo;
  requires = require('../../../requires');
  requires.test('test_setup');
  _ = require('prelude-ls');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleApplier = requires.rule('rule_applier');
  RuleRepo = requires.rule('rule_repo');
  describe('Rule Applier (RuleApplier)', function(){
    var book, ruleRepo, ruleApplier, rules, createRepo, createRuleApplier, execRuleApplier;
    rules = {};
    createRepo = function(){
      return new RuleRepo('static repo').clear();
    };
    createRuleApplier = function(rules, actionRequest){
      ruleRepo = createRepo();
      return ruleApplier = new RuleApplier(ruleRepo, rules, actionRequest);
    };
    execRuleApplier = function(rules, actionRequest){
      return ruleApplier = createRuleApplier(rules, actionRequest).applyRules();
    };
    before(function(){
      return book = new Book('Far and away');
    });
    describe('manage paper', function(){
      context('applied default rule: manage Paper', function(){
        before(function(){
          rules.managePaper = {
            'default': function(){
              return this.ucan('manage', 'Paper');
            }
          };
          return execRuleApplier(rules.managePaper);
        });
        return specify('should add create, edit and delete can-rules', function(){
          return ruleRepo.canRules.should.eql({
            manage: ['Paper'],
            create: ['Paper'],
            edit: ['Paper'],
            'delete': ['Paper']
          });
        });
      });
      return context('applied action rule: manage Book', function(){
        var manageBookRequest;
        before(function(){
          manageBookRequest = {
            action: 'manage'
          };
          rules.manageBook = {
            manage: function(){
              return this.ucan('manage', 'Book');
            }
          };
          return createRuleApplier(rules.manageBook, manageBookRequest).applyActionRules('manage');
        });
        return specify('should add create, edit and delete can-rules', function(){
          return ruleRepo.canRules.should.eql({
            manage: ['Book'],
            create: ['Book'],
            edit: ['Book'],
            'delete': ['Book']
          });
        });
      });
    });
    describe('read any', function(){
      return context('applied default rule: read any', function(){
        before(function(){
          rules.readAny = {
            'default': function(){
              return this.ucan('read', 'any');
            }
          };
          return execRuleApplier(rules.readAny);
        });
        return specify('should add can-rule: read *', function(){
          return ruleRepo.canRules.should.eql({
            read: ['*']
          });
        });
      });
    });
    describe('read *', function(){
      return context('applied default rule: read any', function(){
        var readRules;
        before(function(){
          rules.readStar = {
            'default': function(){
              return this.ucan('read', '*');
            }
          };
          return execRuleApplier(rules.readStar);
        });
        return specify('should add can-rule: read *', function(){
          return ruleRepo.canRules.should.eql({
            read: ['*']
          });
        });
      });
    });
    describe('manage any', function(){
      return context('applied default rule: manage any', function(){
        var manageRules;
        before(function(){
          rules.manageAny = {
            'default': function(){
              return this.ucan('manage', 'any');
            }
          };
          return execRuleApplier(rules.manageAny);
        });
        return specify('should add can-rule: read *', function(){
          return ruleRepo.canRules.should.eql({
            manage: ['*'],
            create: ['*'],
            edit: ['*'],
            'delete': ['*']
          });
        });
      });
    });
    return describe('ensure merge and not override of registered rules', function(){
      return context('applied default rule: manage any and edit Paper', function(){
        var manageRules;
        before(function(){
          rules.manageAny = {
            'default': function(){
              this.ucan('manage', 'any');
              return this.ucan('edit', 'Paper');
            }
          };
          return execRuleApplier(rules.manageAny);
        });
        return specify('should merge rules for edit: *, Paper', function(){
          return ruleRepo.canRules.edit.should.eql(['*', 'Paper']);
        });
      });
    });
  });
}).call(this);
