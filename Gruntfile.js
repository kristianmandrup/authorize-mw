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
        src: ['test/**/rule_applier_test.js',
              'test/**/rule_repo_test.js',
              'test/**/permit_test.js'
        ]
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

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-mocha-test');

  // Default task.
  grunt.registerTask('default', ['mochaTest:test']);

};

