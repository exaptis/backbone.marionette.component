require.config
  baseUrl: '../app/scripts'

  deps: [
    'backbone.marionette'
  ]

  shim:
    backbone:
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'

  paths:
    spec: '../../test/spec' # lives in the test directory
    jquery: '../bower_components/jquery/dist/jquery'
    backbone: '../bower_components/backbone/backbone'
    'backbone.wreqr': '../bower_components/backbone.wreqr/lib/backbone.wreqr'
    'backbone.babysitter': '../bower_components/backbone.babysitter/lib/backbone.babysitter'
    'backbone.marionette': '../bower_components/backbone.marionette/lib/core/backbone.marionette'
    underscore: '../bower_components/underscore/underscore'
    rivets: '../bower_components/rivets/dist/rivets'
    sightglass: '../bower_components/sightglass/index'
    templates: '../templates'
    handlebars: '../bower_components/require-handlebars-plugin/Handlebars'
    json2: '../bower_components/require-handlebars-plugin/hbs/json2'
    hbs: '../bower_components/require-handlebars-plugin/hbs'

  hbs:
    disableI18n: true

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
    if window.mochaPhantomJS then mochaPhantomJS.run() else mocha.run()

