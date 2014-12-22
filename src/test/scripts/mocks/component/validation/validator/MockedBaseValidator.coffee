define [
  'lib/component/validation/validator/BaseValidator'
] , (
  BaseValidator
) ->
  'use strict'

  class MockedBaseValidator extends BaseValidator

    successfulValidator: ->
      validator = new BaseValidator
      sinon.stub validator, 'validate', -> true
      return validator

    unsuccessfulValidator: ->
      validator = new BaseValidator
      sinon.stub validator, 'validate', -> false
      return validator

