define [
  'modules/main/views/TextFieldItemView'
  'modules/main/views/TextAreaItemView'
  'modules/main/views/RadioButtonItemView'
  'modules/main/views/CheckboxItemView'
  'modules/main/views/DropdownItemView'
], (
  TextFieldItemView
  TextAreaItemView
  RadioButtonItemView
  CheckboxItemView
  DropdownItemView
) ->
  'use strict'

  class FormController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showTextFieldComponent: ->
      @app.contentRegion.show new TextFieldItemView

    showTextAreaComponent: ->
      @app.contentRegion.show new TextAreaItemView

    showRadioButtonComponent: ->
      @app.contentRegion.show new RadioButtonItemView

    showCheckboxComponent: ->
      @app.contentRegion.show new CheckboxItemView

    showDropdownComponent: ->
      @app.contentRegion.show new DropdownItemView


