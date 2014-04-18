// Generated by LiveScript 1.2.0
(function(){
  var requires, expect, authorize, Ability, User, Book, user, book, ability, aBook, currentUser;
  requires = require('../../requires');
  expect = require('expect');
  requires.test('test_setup');
  authorize = require('../../index');
  Ability = authorize.Ability;
  User = (function(){
    User.displayName = 'User';
    var prototype = User.prototype, constructor = User;
    function User(name){
      this.name = name;
    }
    return User;
  }());
  Book = (function(){
    Book.displayName = 'Book';
    var prototype = Book.prototype, constructor = Book;
    function Book(title){
      this.title = title;
    }
    return Book;
  }());
  user = function(name){
    return new User(name);
  };
  book = function(title){
    return new Book(title);
  };
  ability = function(user){
    return new Ability(user);
  };
  aBook = book('some book');
  currentUser = user('kris');
  describe('Ability', function(){
    return specify('is an Ability class', function(){
      return expect(new Ability.constructor).to.eq(Ability);
    });
  });
}).call(this);