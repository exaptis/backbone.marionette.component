define [
  'lib/component/validation/validator/EmailAddressValidator'
], (
  EmailAddressValidator
) ->
  'use strict'

  describe 'EmailAddressValidator', ->

    VALID_EMAIL_ADDRESS = 'david@gmail.com'
    INVALID_EMAIL_ADDRESS = '.david@gmail.com'

    beforeEach ->
      @validator = new EmailAddressValidator()

    it 'should match valid email address', ->
      #given
      regex = new RegExp @validator.pattern, @validator.mode

      #when
      result = regex.test VALID_EMAIL_ADDRESS

      #then
      result.should.be.true

    it 'should match invalid email address', ->
      #given
      regex = new RegExp @validator.pattern, @validator.mode

      #when
      result = regex.test INVALID_EMAIL_ADDRESS

      #then
      result.should.be.false

    it 'should call addError on invalid email address', ->
      #given
      @component =
        getValue: -> INVALID_EMAIL_ADDRESS
        addError: new sinon.spy

      #when
      @validator.validate @component

      #then
      @component.addError.should.have.been.calledOnce
      @component.addError.args[0][0].get('pattern').should.be.equal @validator.pattern


    it 'should not call addError on valid email address', ->
      #given
      @component =
        getValue: -> VALID_EMAIL_ADDRESS
        addError: new sinon.spy

      #when
      @validator.validate @component

      #then
      @component.addError.should.have.been.calledNever
