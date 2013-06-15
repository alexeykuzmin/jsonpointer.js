module.exports = function(grunt) {
  'use strict';

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-simple-mocha');


  grunt.initConfig({

    coffee: {
      test: {
        expand: true,
        cwd: 'test',
        src: ['*.coffee'],
        dest: 'test',
        ext: '.compiled.js'
      }
    },


    coffeelint: {
      options: {
        'no_trailing_whitespace': {
          'level': 'error'
        },
        'max_line_length': {
          'level': 'warn'
        }
      },

      test: ['test/test*.coffee']
    },


    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },

      gruntfile: 'Gruntfile.js',
      src: ['src/*.js']
    },


    simplemocha: {
      options: {
        ignoreLeaks: false,
        ui: 'bdd',
        reporter: 'spec'
      },

      test: {
        src: 'test/test*.js'
      }
    }
  });


  grunt.registerTask('check_codestyle', ['jshint', 'coffeelint']);
  grunt.registerTask('run_tests', ['coffee', 'simplemocha']);
  grunt.registerTask('test', ['check_codestyle', 'run_tests']);
  grunt.registerTask('default', 'test');

};
