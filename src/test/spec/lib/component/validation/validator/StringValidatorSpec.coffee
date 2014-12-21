define [
  'lib/component/validation/validator/StringValidator'
], (
  StringValidator
) ->
  'use strict'

  describe 'StringValidator', ->

    MIN_LENGTH = 1
    MAX_LENGTH = 3

    LONG_INPUT = '12345'

    it 'should validate exactLength', ->
      #given
      component =
        getValue: -> LONG_INPUT
        addError: new sinon.spy

      #when
      validator = StringValidator::exactLength MIN_LENGTH
      validator.validate component

      #then
      component.addError.should.have.been.calledOnce

      validationError = component.addError.args[0][0]
      validationError.get('maximum').should.be.equal validator.maximum
      validationError.get('minimum').should.be.equal validator.minimum

    it 'should validate maximumLength', ->
      #given
      component =
        getValue: -> LONG_INPUT
        addError: new sinon.spy

      #when
      validator = StringValidator::maximumLength MAX_LENGTH
      validator.validate component

      #then
      component.addError.should.have.been.calledOnce

      validationError = component.addError.args[0][0]
      expect(validationError.get('maximum')).to.be.equal validator.maximum
      expect(validationError.get('minimum')).to.be.null

    it 'should validate minimumLength', ->
      #given
      component =
        getValue: -> ''
        addError: new sinon.spy

      #when
      validator = StringValidator::minimumLength MIN_LENGTH
      validator.validate component

      #then
      component.addError.should.have.been.calledOnce

      validationError = component.addError.args[0][0]
      expect(validationError.get('minimum')).to.be.equal validator.minimum
      expect(validationError.get('maximum')).to.be.null

    it 'should validate lengthBetween', ->
      #given
      component =
        getValue: -> LONG_INPUT
        addError: new sinon.spy

      #when
      validator = StringValidator::lengthBetween MIN_LENGTH, MAX_LENGTH
      validator.validate component

      #then
      component.addError.should.have.been.calledOnce

      validationError = component.addError.args[0][0]
      expect(validationError.get('minimum')).to.be.equal validator.minimum
      expect(validationError.get('maximum')).to.be.equal validator.maximum


    it 'should set attributes on component tag', ->
      #given
      $tag = $('<input>')

      #when
      validator = new StringValidator MIN_LENGTH, MAX_LENGTH
      validator.onComponentTag {}, $tag

      #then
      expect(parseInt($tag.attr 'minlength')).to.be.equal validator.minimum
      expect(parseInt($tag.attr 'maxlength')).to.be.equal validator.maximum



