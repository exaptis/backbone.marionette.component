define [
  'lib/component/validation/ValidationError'
], (
  ValidationError
) ->
  'use strict'

  describe 'ValidationError', ->

    VALIDATOR_NAME = 'VALIDATOR_NAME'
    COMPONENT_ID = 'COMPONENT_ID'

    PROPERTY1 = 'PROPERTY1'
    PROPERTY2 = 'PROPERTY2'

    beforeEach ->
      @error = new ValidationError null,
        validatorName: VALIDATOR_NAME
        componentId: COMPONENT_ID

    it 'should set validatorName and componentId on initialization', ->
      @error.validatorName.should.be.equal VALIDATOR_NAME
      @error.componentId.should.be.equal COMPONENT_ID

    it 'should construct error message key', ->
      #given
      @error.set
        PROPERTY1: PROPERTY1
        PROPERTY2: PROPERTY2

      #when
      errorMessage = @error.getErrorMessage()

      #then
      errorMessage.should.be.equal "#{VALIDATOR_NAME}.#{COMPONENT_ID}.#{PROPERTY1}.#{PROPERTY2}"
