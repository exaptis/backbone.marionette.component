define [
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/ValidationError'
] , (
  BaseValidator
  ValidationError
) ->
  'use strict'

  class MockedBaseValidator extends BaseValidator

    successfulValidator: ->
      validator = new BaseValidator
      sinon.stub validator, 'validate', -> true
      return validator

    unsuccessfulValidator: ->
      validator = new BaseValidator

      sinon.stub validator, 'validate', (component) ->
        component.add new ValidationError [],
          validatorName: 'VALIDATOR_NAME'
          componentId: 'COMPONENT_ID'

      return validator

