define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
], () ->
  'use strict'

  class StringValidator extends Backbone.Marionette.Component.BaseValidator

    NAME: 'StringValidator'

    constructor: (@minimum = null, @maximum = null, @validationName) ->

    validate: (component) ->
      value = component.getValue()

      if (@minimum and @minimum > value?.length) or (@maximum and @maximum < value?.length)
        options =
          validationName: @validationName
          validatorName: @NAME
          componentId: component.getComponentId()

        error = new Backbone.Marionette.Component.ValidationError value: value, options
        error.set 'minimum', @minimum if @minimum
        error.set 'maximum', @maximum if @maximum

        component.add error

    onComponentTag: (component, tag) ->
      tag.attr 'minlength', @minimum unless tag.attr 'minlength'
      tag.attr 'maxlength', @maximum unless tag.attr 'maxlength'

    exactLength: (length) ->
      new Backbone.Marionette.Component.StringValidator(length, length, 'exactLength')

    maximumLength: (length) ->
      new Backbone.Marionette.Component.StringValidator(null, length, 'maximumLength')

    minimumLength: (length) ->
      new Backbone.Marionette.Component.StringValidator(length, null, 'minimumLength')

    lengthBetween: (minimum, maximum) ->
      new Backbone.Marionette.Component.StringValidator(minimum, maximum, 'between')

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.StringValidator or= StringValidator
