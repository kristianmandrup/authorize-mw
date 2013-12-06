/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    mochaTest: {
      test: {
        options: {
          reporter: 'spec'
        },
        src: ['test/**/permit_test.js']
      },
      all: {
        options: {
          reporter: 'spec'
        },
        src: ['test/**/*.js']
      },
      acceptance_test: {
        options: {
          reporter: 'spec'
        },
        src: ['test/**/ability_test.js']
      }
    }

  });

  //'test/**/*.js'
  // These plugins provide necessary tasks.
  //grunt.loadNpmTasks('grunt-contrib-jshint');
  //grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-mocha-test');

  // Default task.
  grunt.registerTask('default', ['mochaTest:acceptance_test']);

};

