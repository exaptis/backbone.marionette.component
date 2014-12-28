define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], () ->
  'use strict'

  class PatternValidator extends Backbone.Marionette.Component.BaseValidator

    NAME: 'PatternValidator'

    constructor: (@pattern, @mode = 'ig') ->

    validate: (component) ->
      value = component.getValue()

      regex = new RegExp @pattern, @mode

      unless (regex.test value)
        options =
          validatorName: @NAME
          validationName: 'pattern'
          componentId: component.getComponentId()

        properties =
          pattern : @pattern
          value: value

        component.add new Backbone.Marionette.Component.ValidationError properties, options

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.PatternValidator or= PatternValidator
