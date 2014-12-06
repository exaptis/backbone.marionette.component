define [
  'backbone'
  './states/ShowMarkupComponentState'
  './states/ShowFormComponentState'
], (
  Backbone
  ShowMarkupComponentState
  ShowFormComponentState
) ->
  'use strict'

  class MainModule extends Backbone.Marionette.Module

    initialize: ->
      ShowMarkupComponentState.initialize(@)
      ShowFormComponentState.initialize(@)
