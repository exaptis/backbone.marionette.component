define [
  'lib/component/validation/validator/EmailAddressValidator'
  'mocks/component/MockedComponent'
], (
  EmailAddressValidator
  MockedComponent
) ->
  'use strict'

  describe 'EmailAddressValidator', ->

    VALID_EMAIL_ADDRESS = 'david@gmail.com'
    INVALID_EMAIL_ADDRESS = '.david@gmail.com'

    beforeEach ->
      @validator = new Backbone.Marionette.Component.EmailAddressValidator()

    describe 'regular expression', ->

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

    describe 'validation', ->

      beforeEach ->
        @component = new MockedComponent 'MockedComponent1'

      afterEach ->
        @component.getValue.restore()

      it 'should call add on invalid email address', ->
        #given
        sinon.stub @component, 'getValue', -> INVALID_EMAIL_ADDRESS

        #when
        @validator.validate @component

        #then
        @component.add.should.have.been.calledOnce
        @component.add.args[0][0].get('pattern').should.be.equal @validator.pattern


      it 'should not call add on valid email address', ->
        #given
        sinon.stub @component, 'getValue', -> VALID_EMAIL_ADDRESS

        #when
        @validator.validate @component

        #then
        @component.add.should.have.been.calledNever
