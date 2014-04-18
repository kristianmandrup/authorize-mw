// Generated by LiveScript 1.2.0
(function(){
  var _, underscore, filePath, testPath, libPath, slice$ = [].slice;
  require('sugar');
  _ = require('prelude-ls');
  underscore = function(items){
    var strings;
    items = items.flatten();
    strings = items.map(function(item){
      return String(item);
    });
    return _.map(function(it){
      return it.underscore();
    }, strings);
  };
  filePath = function(){
    var paths, upaths;
    paths = slice$.call(arguments);
    upaths = underscore.apply(null, paths);
    return ['.', upaths].flatten().join('/');
  };
  testPath = function(){
    var paths;
    paths = slice$.call(arguments);
    return this.filePath.apply(this, ['test'].concat(slice$.call(paths)));
  };
  libPath = function(){
    var paths;
    paths = slice$.call(arguments);
    return this.filePath.apply(this, ['lib'].concat(slice$.call(paths)));
  };
  module.exports = {
    util: function(path){
      return this.lib('util', path);
    },
    mw: function(path){
      return this.lib('mw', path);
    },
    rule: function(path){
      return this.lib('rule', path);
    },
    permit: function(path){
      return this.lib('permit', path);
    },
    test: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(testPath(paths));
    },
    fixture: function(path){
      return this.test('fixtures', path);
    },
    fix: function(path){
      return this.fixture(path);
    },
    factory: function(path){
      return this.test('factories', path);
    },
    fac: function(path){
      return this.factory(path);
    },
    file: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(filePath.apply(null, paths));
    },
    lib: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(libPath.apply(null, paths));
    },
    afile: function(path){
      return require(['.', path].join('/'));
    },
    m: function(path){
      return this.file(path);
    },
    files: function(){
      var paths, self;
      paths = slice$.call(arguments);
      self = this;
      return paths.map(function(path){
        return self.file(path);
      });
    },
    fixtures: function(){
      var paths, self;
      paths = slice$.call(arguments);
      self = this;
      return paths.map(function(path){
        return self.fixture(path);
      });
    },
    tests: function(){
      var paths, self;
      paths = slice$.call(arguments);
      self = this;
      return paths.map(function(path){
        return self.test(path);
      });
    }
  };
}).call(this);