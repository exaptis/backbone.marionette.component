require.config
  baseUrl: '/scripts'

  deps: [
    'backbone.marionette'
    'main'
  ]

  shim:
    backbone:
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'

  paths:
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
