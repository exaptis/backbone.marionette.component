define [
  'modules/main/views/TextFieldItemView'
], (
  TextFieldItemView
) ->
  'use strict'

  class FormController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showTextFieldComponent: ->
      @app.contentRegion.show new TextFieldItemView


