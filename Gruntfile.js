module.exports = function(grunt) {
  'use strict';

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-simple-mocha');


  grunt.initConfig({

    coffee: {
      tests: {
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

      tests: ['test/test*.coffee']
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
        compilers: {
          coffee: 'coffee-script'
        },
        ignoreLeaks: false,
        ui: 'bdd',
        reporter: 'spec'
      },

      tests: {
        src: 'test/test*'
      }
    }
  });


  var metaTasks = {
    'check-code': ['codestyle', 'tests'],
    'codestyle': ['jshint', 'coffeelint'],
    compile: 'coffee',
    'default': 'check-code',
    tests: ['simplemocha']
  };

  for (var name in metaTasks) {
    if (metaTasks.hasOwnProperty(name)) {
      var tasksList = metaTasks[name];
      grunt.registerTask(name, tasksList);
    }
  }

};
