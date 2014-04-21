// Generated by LiveScript 1.2.0
(function(){
  var Permit, AdminPermit, GuestPermit;
  Permit = require('permit-authorize').Permit;
  module.exports = {
    AdminPermit: AdminPermit = (function(superclass){
      var prototype = extend$((import$(AdminPermit, superclass).displayName = 'AdminPermit', AdminPermit), superclass).prototype, constructor = AdminPermit;
      prototype.includes = function(){
        return {
          'user': {
            'role': 'admin'
          }
        };
      };
      prototype.excludes = function(){
        return {
          'context': 'dashboard'
        };
      };
      function AdminPermit(){
        AdminPermit.superclass.apply(this, arguments);
      }
      return AdminPermit;
    }(Permit)),
    GuestPermit: GuestPermit = (function(superclass){
      var prototype = extend$((import$(GuestPermit, superclass).displayName = 'GuestPermit', GuestPermit), superclass).prototype, constructor = GuestPermit;
      function GuestPermit(name, desc){
        GuestPermit.superclass.apply(this, arguments);
      }
      prototype.match = function(access){
        return true;
      };
      return GuestPermit;
    }(Permit))
  };
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
