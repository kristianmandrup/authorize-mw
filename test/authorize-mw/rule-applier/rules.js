// Generated by LiveScript 1.2.0
(function(){
  module.exports = {
    setup: {
      basicRules: {
        edit: function(){
          this.ucan('edit', 'Book');
          return this.ucannot('write', 'Book');
        },
        read: function(){
          this.ucan('read', ['Book', 'Paper', 'Project']);
          return this.ucannot('delete', ['Paper', 'Project']);
        }
      }
    }
  };
}).call(this);
