define [
  'modules/main/views/TextFieldItemView'
  'modules/main/views/TextAreaItemView'
], (
  TextFieldItemView
  TextAreaItemView
) ->
  'use strict'

  class FormController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showTextFieldComponent: ->
      @app.contentRegion.show new TextFieldItemView

    showTextAreaComponent: ->
      @app.contentRegion.show new TextAreaItemView


