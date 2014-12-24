define [
  'lib/component/validation/ValidationError'
], (
  ValidationError
) ->
  'use strict'

  describe 'ValidationError', ->

    VALIDATOR_NAME = 'VALIDATOR_NAME'
    VALIDATION_NAME = 'VALIDATION_NAME'
    COMPONENT_ID = 'COMPONENT_ID'

    PROPERTY1 = 'PROPERTY1'
    PROPERTY2 = 'PROPERTY2'

    beforeEach ->
      @error = new ValidationError null,
        validatorName: VALIDATOR_NAME
        validationName: VALIDATION_NAME
        componentId: COMPONENT_ID


    it 'should set validatorName and componentId on initialization', ->
      @error.validatorName.should.be.equal VALIDATOR_NAME
      @error.componentId.should.be.equal COMPONENT_ID

    it 'should construct error message key', ->
      #given
      properties =
        PROPERTY1: PROPERTY1
        PROPERTY2: PROPERTY2

      @error.set properties

      #when
      errorMessage = @error.getErrorKey()
      errorValues = @error.getErrorValues()

      #then
      errorMessage.should.be.equal "#{COMPONENT_ID}.#{VALIDATOR_NAME}.#{VALIDATION_NAME}"
      errorValues.should.be.eql properties

    it 'should update errorMessage on every change of attributes', ->
      #given
      sinon.spy @error, 'updateErrorMessage'

      #when
      @error.set PROPERTY1: PROPERTY1
      @error.set PROPERTY2: PROPERTY2

      #then
      setTimeout =>
        @error.updateErrorMessage.should.have.been.calledTwice
      ,
        500
