define [
  'modules/main/views/LabelItemView'
], (
  LabelItemView
) ->
  'use strict'

  class LabelController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showLabelComponent: ->
      @app.contentRegion.show new LabelItemView


