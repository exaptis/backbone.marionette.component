define [
  'lib/component/Component'
  'mocks/component/validation/validator/MockedBaseValidator'
], (
  Component
  MockedBaseValidator
) ->
  'use strict'

  describe 'Component', ->
    beforeEach ->
      @component = new Component 'componentId'
      @viewInstance =
        $: jQuery
        $el: $('<div>')

    it 'should be an instance of Component', ->
      @component.should.be.an.instanceof Component
      @component.constructor.name.should.be.equal 'Component'

    it 'should throw an error if no Id is provided', ->
      expect(-> new Component()).to.throw(Error)

    it 'should set and get componentId', ->
      #given
      newComponentId = "newComponentId"

      #when
      @component.setComponentId newComponentId

      #then
      @component.getComponentId().should.be.equal newComponentId

    it 'should set and get viewInstance', ->
      #when
      @component.setViewInstance @viewInstance

      #then
      @component.getViewInstance().should.be.equal @viewInstance

    it 'should set and get model', ->
      #given
      model = new Backbone.Model()

      #when
      @component.setModel model

      #then
      @component.getModel().should.be.equal model

    it 'should set and get property', ->
      #given
      PROPERTY = 'PROPERTY'

      #when
      @component.setProperty PROPERTY

      #then
      @component.getProperty().should.be.equal PROPERTY

    it 'should set and get parent component', ->
      #given
      PARENT = 'PARENT'

      #when
      @component.setParent PARENT

      #then
      @component.getParent().should.be.equal PARENT

    it 'should return component value', ->
      #given
      model = new Backbone.Model key: 'value'

      #when
      @component.setModel model
      @component.setProperty 'key'

      #then
      @component.getValue().should.be.equal 'value'

    it 'should increase bindingId per instance', ->
      #given
      component1 = new Component 'componentId1'
      component2 = new Component 'componentId2'

      #when
      counter1 = parseInt component1.cid.slice 1
      counter2 = parseInt component2.cid.slice 1

      #then
      counter1.should.be.equal counter2 - 1

    it 'should return cid:model object for binding', ->
      #given
      model = new Backbone.Model()
      expectedModelData = {}
      expectedModelData["#{@component.cid}"] = model

      #when
      @component.setModel model

      #then
      @component.getModelData().should.be.eql expectedModelData


    it 'should throw an error if the element can not be found inside the view', ->
      #given
      @component.setViewInstance(@viewInstance)
      errorMessage = "element with id '#{@component.getComponentId()}' could not be found"

      #when
      getMissingDomNode = =>
        @component.getDomNode()

      #then
      getMissingDomNode.should.throw errorMessage

    describe 'validation', ->

      beforeEach ->
        @successfulValidator = MockedBaseValidator::successfulValidator()
        @unsuccessfulValidator = MockedBaseValidator::unsuccessfulValidator()

      it 'should validate all validators', ->
          #given
        @component.add @successfulValidator, @unsuccessfulValidator

        #when
        @component.validate()

        #then
        @successfulValidator.validate.should.have.been.calledOnce
        @unsuccessfulValidator.validate.should.have.been.calledOnce

      it 'should clear validationErrors before validation', ->
        #given
        @component.add @unsuccessfulValidator

        #when
        @component.validate()
        @component.validate()
        @component.validate()

        #then
        @unsuccessfulValidator.validate.should.have.been.calledThrice
        @component.getValidationErrors().length.should.be.equal 1





