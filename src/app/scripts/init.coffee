require.config
  baseUrl: '/scripts'

  deps: [
    'main'
    'backbone.marionette'
  ]

  shim:
    backbone:
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'

    bootstrap:
      deps: [
        'jquery'
      ]

    prism:
      exports: "Prism"

    'prism-coffeescript':
      deps: [ 'prism' ]

    ripples:
      deps: ['jquery', 'material']

    material:
      deps: ['jquery']

  paths:
    jquery: '../bower_components/jquery/dist/jquery'
    backbone: '../bower_components/backbone/backbone'
    'backbone.wreqr': '../bower_components/backbone.wreqr/lib/backbone.wreqr'
    'backbone.babysitter': '../bower_components/backbone.babysitter/lib/backbone.babysitter'
    'backbone.marionette': '../bower_components/backbone.marionette/lib/core/backbone.marionette'
    bootstrap: '../bower_components/bootstrap/dist/js/bootstrap'
    underscore: '../bower_components/underscore/underscore'
    'underscore.string': '../bower_components/underscore.string/dist/underscore.string.min'
    rivets: '../bower_components/rivets/dist/rivets'
    ripples: '../bower_components/bootstrap-material-design/scripts/ripples'
    material: '../bower_components/bootstrap-material-design/scripts/material'
    sightglass: '../bower_components/sightglass/index'
    prism: '../bower_components/prismjs/prism'
    'prism-coffeescript': '../bower_components/prismjs/components/prism-coffeescript'
    selectize: '../bower_components/selectize/dist/js/standalone/selectize'
    templates: '../templates'
    handlebars: '../bower_components/require-handlebars-plugin/Handlebars'
    json2: '../bower_components/require-handlebars-plugin/hbs/json2'
    hbs: '../bower_components/require-handlebars-plugin/hbs'
    i18n: '../bower_components/i18next/i18next.amd'
    spec: '../../test/spec' # lives in the test directory
    mocks: '../../test/scripts/mocks' # lives in the test directory
    'StateManager': '../bower_components/backbone.stateful/dist/StateManager'
    'State': '../bower_components/backbone.stateful/dist/State'

  hbs:
    disableI18n: true


