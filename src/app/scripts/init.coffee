require.config
  baseUrl: "/scripts"

# starting point for application
  deps: [
    "backbone.marionette"
    "main"
  ]
  shim:
    backbone:
      deps: [
        "underscore"
        "jquery"
      ]
      exports: "Backbone"

    bootstrap:
      deps: ["jquery"]
      exports: "jquery"

  paths:
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
