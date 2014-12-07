define [
  'modules/main/views/WelcomeItemView'
], (
  WelcomeItemView
) ->
  'use strict'

  class HomeController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showWelcomePage: ->
      @app.contentRegion.show new WelcomeItemView


