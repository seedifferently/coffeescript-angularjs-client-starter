exports.config =
  # Tests
  specs: ['src/tests/**/*_e2e.coffee']
  # Drivers config
#  chromeDriver: './node_modules/protractor/selenium/chromedriver'
  directConnect: true
  # Browsers config
  capabilities:
    browserName: 'chrome'
#    shardTestFiles: true
#    maxInstances: 3
  # Test config
  baseUrl: 'http://localhost:8080/'
  # Test framework config
  framework: 'jasmine'
  jasmineNodeOpts:
    isVerbose: true
    showColors: true
    includeStackTrace: true
