// Generated by LiveScript 1.2.0
(function(){
  var requires, _, lo, Permit, PermitFilter, Debugger, Allower;
  requires = require('../requires');
  _ = require('prelude-ls');
  lo = require('lodash');
  require('sugar');
  Permit = requires.lib('permit');
  PermitFilter = requires.permit('permit_filter');
  Debugger = requires.lib('debugger');
  module.exports = Allower = (function(){
    Allower.displayName = 'Allower';
    var prototype = Allower.prototype, constructor = Allower;
    importAll$(prototype, arguments[0]);
    function Allower(accessRequest){
      this.accessRequest = accessRequest;
      this.permits = PermitFilter.filter(this.accessRequest);
    }
    prototype.allows = function(){
      this.debug('allows', this.accessRequest);
      return this.test('allows');
    };
    prototype.disallows = function(){
      this.debug('disallows', this.accessRequest);
      return this.test('disallows');
    };
    prototype.test = function(allowType){
      var i$, ref$, len$, permit;
      for (i$ = 0, len$ = (ref$ = this.permits).length; i$ < len$; ++i$) {
        permit = ref$[i$];
        this.debug('test permit', allowType, permit);
        this.debug('with rules', permit.rules);
        if (this.debugging) {
          permit.debugOn();
        }
        permit.applyRules(this.accessRequest);
        this.debug('permit rules');
        if (permit[allowType](this.accessRequest)) {
          return true;
        }
      }
      return false;
    };
    return Allower;
  }(Debugger));
  lo.extend(Allower, Debugger);
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);