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

    prismjs:
      exports: "Prism"

    prismjsCoffeescript:
      deps: [ 'prismjs' ]

    ripples:
      deps: ['jquery', 'material']

    material:
      deps: ['jquery']

  paths:
    hbs: '../../../bower_components/require-handlebars-plugin/hbs'
    i18next: '../../../bower_components/i18next/i18next.amd'
    prismjsCoffeescript: '../../../bower_components/prismjs/components/prism-coffeescript'
    templates: '../templates'

  hbs:
    disableI18n: true


