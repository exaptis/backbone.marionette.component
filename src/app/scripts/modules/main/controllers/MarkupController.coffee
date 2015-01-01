define [
  'modules/main/views/LabelItemView'
], (
  LabelItemView
) ->
  'use strict'

  class MarkupController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showLabelComponent: ->
      @app.contentRegion.show new LabelItemView


