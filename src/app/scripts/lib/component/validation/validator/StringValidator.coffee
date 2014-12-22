define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class StringValidator extends BaseValidator

    NAME: 'StringValidator'

    constructor: (@minimum = null, @maximum = null) ->

    validate: (component) ->
      value = component.getValue()

      if (@minimum and @minimum > value) or (@maximum and @maximum < value)
        options =
          validatorName: @NAME
          componentId: component.getComponentId()

        error = new ValidationError null, options
        error.set 'minimum', @minimum if @minimum
        error.set 'maximum', @maximum if @maximum

        component.add error

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

