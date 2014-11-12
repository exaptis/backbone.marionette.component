define [
  'modules/main/views/LabelItemView'
], (
  LabelItemView
) ->
  'use strict'

  class LabelController extends Backbone.Marionette.Controller

    initialize: (@app) ->
      @app.contentRegion.show new LabelItemView


