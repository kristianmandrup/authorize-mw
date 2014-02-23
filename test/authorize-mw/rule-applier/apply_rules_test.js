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
    var book, debugRepo;
    debugRepo = function(txt, repo){
      console.log(txt, repo);
      console.log(repo.canRules);
      return console.log(repo.cannotRules);
    };
    before(function(){
      return book = new Book('Far and away');
    });
    return describe('apply-rules', function(){
      describe('static', function(){
        var readAccessRequest, ruleRepo, ruleApplier, rules;
        before(function(){
          rules = {
            edit: function(){
              this.ucan('edit', 'Book');
              return this.ucannot('write', 'Book');
            },
            read: function(){
              this.ucan('read', 'Project');
              return this.ucannot('delete', 'Paper');
            },
            'default': function(){
              return this.ucan('read', 'Paper');
            }
          };
          readAccessRequest = {
            action: 'read',
            subject: book
          };
          ruleRepo = new RuleRepo('static repo').clear();
          ruleApplier = new RuleApplier(ruleRepo, rules);
          return ruleApplier.applyRules();
        });
        specify('adds all static can rules', function(){
          return ruleRepo.canRules.should.be.eql({
            read: ['Paper']
          });
        });
        return specify('adds all static cannot rules', function(){
          return ruleRepo.cannotRules.should.be.eql({});
        });
      });
      return describe('dynamic', function(){
        var readAccessRequest, ruleRepo, ruleApplier, rules;
        before(function(){
          rules = {
            edit: function(){
              this.ucan('edit', 'Book');
              return this.ucannot('write', 'Book');
            },
            read: function(){
              this.ucan('read', 'Project');
              return this.ucannot('delete', 'Paper');
            }
          };
          readAccessRequest = {
            action: 'read',
            subject: book
          };
          ruleRepo = new RuleRepo('action repo').clear();
          ruleApplier = new RuleApplier(ruleRepo, rules, readAccessRequest);
          return ruleApplier.applyRules(readAccessRequest);
        });
        specify('adds all dynamic can rules (only read)', function(){
          return ruleRepo.canRules.should.be.eql({
            read: ['Project']
          });
        });
        return specify('adds all dynamic cannot rules (only read)', function(){
          return ruleRepo.cannotRules.should.be.eql({
            'delete': ['Paper']
          });
        });
      });
    });
  });
}).call(this);
