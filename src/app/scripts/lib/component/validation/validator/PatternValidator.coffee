define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class PatternValidator extends BaseValidator

    constructor: (@pattern, @mode = 'ig') ->

    validate: (component) ->
      value = component.getValue()

      regex = new RegExp @pattern, @mode

      unless (regex.test value)
        error = new ValidationError pattern: @pattern
        component.addError error
