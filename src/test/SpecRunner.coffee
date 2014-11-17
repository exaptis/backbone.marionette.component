require ['../app/scripts/require-config'], ->
  'use strict'

  require.config
    baseUrl: '../app/scripts'
    deps: [
      'backbone.marionette'
    ]

  ###
  Environments such PhantomJS 1.8.* do not provides the bind method on Function prototype.
  This shim will ensure that source-map generation will not break when running on PhantomJS.
  ###
  unless Function::bind
    Function::bind = (args...) ->
      'use strict'
      self = this
      ()->
        self.apply args[0], args.splice(1)

  # require test suite
  require [
    'jquery'
    'spec/testSuite'
  ], ($, testSuite) ->
    'use strict'
    require testSuite.specs, ->
      if window.PHANTOMJS then blanket.options 'reporter', '../app/node_modules/grunt-blanket-mocha/support/grunt-reporter.js'
      if window.mochaPhantomJS then mochaPhantomJS.run() else mocha.run()
