define [
  'lib/component/validation/validator/StringValidator'
  'mocks/component/MockedComponent'
], (
  StringValidator
  MockedComponent
) ->
  'use strict'

  describe 'StringValidator', ->

    MIN_LENGTH = 1
    MAX_LENGTH = 3
    LONG_INPUT = '12345'

    describe 'validation methods', ->

      beforeEach ->
        @component = new MockedComponent 'MockedComponent1'

      afterEach ->
        @component.getValue.restore()

      it 'should validate exactLength', ->
        #given
        sinon.stub @component, 'getValue', -> LONG_INPUT

        #when
        validator = StringValidator::exactLength MIN_LENGTH
        validator.validate @component

        #then
        @component.add.should.have.been.calledOnce
        validationError = @component.add.args[0][0]
        validationError.get('maximum').should.be.equal validator.maximum
        validationError.get('minimum').should.be.equal validator.minimum


      it 'should validate maximumLength', ->
        #given
        sinon.stub @component, 'getValue', -> LONG_INPUT

        #when
        validator = StringValidator::maximumLength MAX_LENGTH
        validator.validate @component

        #then
        @component.add.should.have.been.calledOnce

        validationError = @component.add.args[0][0]
        expect(validationError.get('maximum')).to.be.equal validator.maximum
        expect(validationError.get('minimum')).to.be.undefined

      it 'should validate minimumLength', ->
        #given
        sinon.stub @component, 'getValue', -> null

        #when
        validator = StringValidator::minimumLength MIN_LENGTH
        validator.validate @component

        #then
        @component.add.should.have.been.calledOnce

        validationError = @component.add.args[0][0]
        expect(validationError.get('minimum')).to.be.equal validator.minimum
        expect(validationError.get('maximum')).to.be.undefined

      it 'should validate lengthBetween', ->
        #given
        sinon.stub @component, 'getValue', -> LONG_INPUT

        #when
        validator = StringValidator::lengthBetween MIN_LENGTH, MAX_LENGTH
        validator.validate @component

        #then
        @component.add.should.have.been.calledOnce

        validationError = @component.add.args[0][0]
        expect(validationError.get('minimum')).to.be.equal validator.minimum
        expect(validationError.get('maximum')).to.be.equal validator.maximum


    it 'should set attributes on @component tag', ->
      #given
      $tag = $('<input>')

      #when
      validator = new StringValidator MIN_LENGTH, MAX_LENGTH
      validator.onComponentTag null, $tag

      #then
      expect(parseInt($tag.attr 'minlength')).to.be.equal validator.minimum
      expect(parseInt($tag.attr 'maxlength')).to.be.equal validator.maximum



