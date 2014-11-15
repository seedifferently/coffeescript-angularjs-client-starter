module.exports = (config) ->
  config.set
    autoWatch: true
    frameworks: ['jasmine']
    browsers: ['Chrome']
    files: [
      'www/vendor/lodash/dist/lodash.js'
      'www/vendor/jquery/dist/jquery.js'
      'www/vendor/bootstrap/dist/js/bootstrap.js'
      'www/vendor/angular/angular.js'
      'www/vendor/angular-mocks/angular-mocks.js'
      'www/vendor/angular-route/angular-route.js'
      'www/vendor/angular-base64/angular-base64.js'
      'www/vendor/angular-local-storage/dist/angular-local-storage.js'
      'www/vendor/restangular/dist/restangular.js'
      'www/app.js'
      'src/tests/**/*_unit.coffee'
    ]
    preprocessors:
      'www/app.js': 'coverage'
      'src/tests/**/*.coffee': 'coffee'
    reporters: ['progress', 'coverage']
    coverageReporter:
      type : 'html'
      dir : '.coverage/'
    plugins: [
      'karma-chrome-launcher'
      'karma-jasmine'
      'karma-coffee-preprocessor'
      'karma-coverage'
    ]
