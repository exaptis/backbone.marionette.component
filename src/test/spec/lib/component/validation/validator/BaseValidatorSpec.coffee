define [
  'lib/component/validation/validator/BaseValidator'
], (
  BaseValidator
) ->
  'use strict'

  describe 'BaseValidator', ->
    it 'has validate and onComponentTag function', ->
      BaseValidator::validate.should.be.a 'function'
      BaseValidator::onComponentTag.should.be.a 'function'
