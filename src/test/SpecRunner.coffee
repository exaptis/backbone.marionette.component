require.config
  baseUrl: "../app/scripts"
  deps: ['marionette']
  paths:
    spec: "../../test/spec" # lives in the test directory
    jquery: "../bower_components/jquery/dist/jquery"
    backbone: "../bower_components/backbone/backbone"
    marionette: "../bower_components/backbone.marionette/lib/core/backbone.marionette"
    underscore: "../bower_components/underscore/underscore"
    rivets: '../bower_components/rivets/dist/rivets'

  # Shortcut the templates dir to tmpl
    tmpl: "../templates"

  # handlebars from the require handlerbars plugin below
    handlebars: "../bower_components/require-handlebars-plugin/Handlebars"

  # require handlebars plugin - Alex Sexton
    json2: "../bower_components/require-handlebars-plugin/hbs/json2"
    hbs: "../bower_components/require-handlebars-plugin/hbs"

  hbs:
    disableI18n: true

###
Environments such PhantomJS 1.8.* do not provides the bind method on Function prototype.
This shim will ensure that source-map generation will not break when running on PhantomJS.
###
unless Function::bind
  Function::bind = (args...) ->
    "use strict"
    self = this
    ()->
      self.apply args[0], args.splice(1)

# require test suite
require [
  "jquery"
  "spec/testSuite"
], ($, testSuite) ->
  "use strict"

  # on dom ready require all specs and run
  $ ->
    require testSuite.specs, ->
      if window.mochaPhantomJS then mochaPhantomJS.run() else mocha.run()
      return

