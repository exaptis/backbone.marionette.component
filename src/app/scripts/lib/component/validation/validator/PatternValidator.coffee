define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class PatternValidator extends BaseValidator

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

        component.add new ValidationError properties, options
