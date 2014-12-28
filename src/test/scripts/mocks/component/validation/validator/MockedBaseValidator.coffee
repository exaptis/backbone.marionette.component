define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
] , (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class MockedBaseValidator extends Backbone.Marionette.Component.BaseValidator

    successfulValidator: ->
      validator = new Backbone.Marionette.Component.BaseValidator
      sinon.stub validator, 'validate', -> true
      return validator

    unsuccessfulValidator: ->
      validator = new Backbone.Marionette.Component.BaseValidator

      sinon.stub validator, 'validate', (component) ->
        component.add new ValidationError [],
          validatorName: 'VALIDATOR_NAME'
          componentId: 'COMPONENT_ID'

      return validator

