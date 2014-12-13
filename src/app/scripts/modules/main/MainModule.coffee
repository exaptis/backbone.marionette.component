define [
  'backbone'
  './states/ApplicationState'
  './states/WelcomeState'
  './states/ShowMarkupComponentState'
  './states/ShowFormComponentState'
  './states/ShowViewComponentState'
], (
  Backbone
  ApplicationState
  WelcomeState
  ShowMarkupComponentState
  ShowFormComponentState
  ShowViewComponentState
) ->
  'use strict'

  class MainModule extends Backbone.Marionette.Module

    initialize: ->
      WelcomeState.initialize(@)
      ShowMarkupComponentState.initialize(@)
      ShowFormComponentState.initialize(@)
      ShowViewComponentState.initialize(@)
