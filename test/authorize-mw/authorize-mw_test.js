// Generated by LiveScript 1.2.0
(function(){
  var User, Book, createRequest, createUser, createPermit, AuthorizeMw;
  require('../test_setup');
  User = require('../fixtures/user');
  Book = require('../fixtures/book');
  createRequest = require('../factories/create_request');
  createUser = require('../factories/create_user');
  createPermit = require('../factories/create_permit');
  AuthorizeMw = require('../../lib/authorize_mw');
  describe('AuthorizeMw', function(){
    var ctx, users, requests, permits, authorizeMws, authorizeMw;
    users = {};
    requests = {};
    permits = {};
    authorizeMws = {};
    authorizeMw = function(context){
      return new AuthorizeMw(context);
    };
    before(function(){
      var book;
      book = new Book({
        title: 'hello'
      });
      users.guest = createUser.guest();
      permits.guest = createPermit.matching.role.guest();
      ctx = {
        currentUser: users.guest
      };
      return authorizeMws.basic = authorizeMw(ctx);
    });
    describe('create', function(){
      specify('should set context', function(){
        return authorizeMws.basic.context.should.eql(ctx);
      });
      return specify('should set current-user', function(){
        return authorizeMws.basic.currentUser.should.eql(ctx.currentUser);
      });
    });
    describe('authorizer', function(){
      specify('should set authorizer', function(){
        return authorizeMws.basic.authorizer().should.not.eql(void 8);
      });
      return specify('should set authorizer user to current user', function(){
        return authorizeMws.basic.authorizer().user.should.eql(ctx.currentUser);
      });
    });
    describe('run', function(){
      return context('read book request by guest user', function(){
        before(function(){
          requests.readBook = {
            action: 'read',
            collection: 'books'
          };
          return authorizeMws.basic.clear();
        });
        return specify('user is authorized to read book', function(){
          return authorizeMws.basic.runAlone(requests.readBook).should.be['true'];
        });
      });
    });
    describe('run', function(){
      return context('read book request by guest user', function(){
        before(function(){
          requests.createBook = {
            action: 'create',
            collection: 'books'
          };
          return authorizeMws.basic.clear();
        });
        return specify('user is NOT authorized to create a new book', function(){
          return authorizeMws.basic.runAlone(requests.createBook).should.be['false'];
        });
      });
    });
    return describe('run', function(){
      return context('edit user request by guest user', function(){
        before(function(){
          requests.editUser = {
            action: 'edit',
            data: users.guest
          };
          requests.createUser = {
            action: 'create',
            data: users.guest
          };
          permits.admin = createPermit.matching.role.admin();
          users.admin = createUser.admin();
          ctx = {
            currentUser: users.admin
          };
          return authorizeMws.user = authorizeMw(ctx);
        });
        specify('admin user is authorized to edit another user', function(){
          return authorizeMws.user.runAlone(requests.editUser).should.be['true'];
        });
        return specify('admin user is NOT authorized to create another user', function(){
          return authorizeMws.user.runAlone(requests.createUser).should.be['false'];
        });
      });
    });
  });
}).call(this);
