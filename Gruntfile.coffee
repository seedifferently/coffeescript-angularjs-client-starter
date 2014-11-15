module.exports = (grunt) ->
  # Config
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    copy:
      images:
        files: [
          expand: true,
          cwd: 'src/assets/images'
          src: '**'
          dest: 'www/img'
        ]

    jade:
      compile:
        files: [
          expand: true,
          cwd: 'src'
          src: '**/*.jade'
          dest: 'www'
          ext: '.html'
        ]

    coffee:
      compile:
        options:
          join: true
        files:
          'www/app.js': [
            'src/app.coffee'
            'src/app/**/*.coffee'
            'src/shared/**/*.coffee'
          ],
          'www/js/application.js': [
            'src/assets/scripts/**/*.coffee'
          ]

    sass:
      compile:
        files:
          'www/css/application.css': [
            'src/assets/styles/**/*.sass'
          ]

    uglify:
      app:
        files:
          'www/app.min.js': [
            'www/js/*.js'
            'www/app.js'
          ]

    connect:
      server:
        options:
          hostname: 'localhost'
          port: 8080
          base: 'www'

    watch:
      files: ['src/**/*.jade', 'src/**/*.coffee', 'src/assets/**']
      tasks: [
        'copy:images'
        'jade'
        'coffee'
        'sass'
        'uglify'
      ]
      options:
        livereload: true

  # Imports
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Tasks
  grunt.registerTask 'build', [
    'copy:images'
    'jade'
    'coffee'
    'sass'
    'uglify'
  ]

  grunt.registerTask 'serve', [
    'connect:server:keepalive'
  ]

  grunt.registerTask 'default', [
    'copy:images'
    'jade'
    'coffee'
    'sass'
    'uglify'
    'connect:server'
    'watch'
  ]
