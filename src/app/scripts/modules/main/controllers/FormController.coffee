define [
  'modules/main/views/TextAreaItemView'
  'modules/main/views/TextFieldItemView'
  'modules/main/views/RadioButtonItemView'
  'modules/main/views/CheckboxItemView'
  'modules/main/views/DropdownItemView'
  'modules/main/views/ButtonItemView'
], (
  TextAreaItemView
  TextFieldItemView
  RadioButtonItemView
  CheckboxItemView
  DropdownItemView
  ButtonItemView
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

    showButtonComponent: ->
      @app.contentRegion.show new ButtonItemView


