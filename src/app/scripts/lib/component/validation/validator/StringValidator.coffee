define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class StringValidator extends BaseValidator

    constructor: (@minimum = null, @maximum = null) ->

    validate: (component) ->
      value = component.getValue()

      if (@minimum and @minimum > value) or (@maximum and @maximum < value)
        error = new ValidationError @

        error.set 'minimum', @minimum unless @minimum
        error.set 'maximum', @maximum unless @maximum

        component.addError error

    onComponentTag: (component, tag) ->
      tag.attr 'minlength', @minimum unless tag.attr 'minlength'
      tag.attr 'maxlength', @maximum unless tag.attr 'maxlength'

    exactLength: (length) ->
      new StringValidator(length, length)

    maximumLength: (length) ->
      new StringValidator(null, length)

    minimumLength: (length) ->
      new StringValidator(length, null)

    lengthBetween: (minimum, maximum) ->
      new StringValidator(minimum, maximum)

