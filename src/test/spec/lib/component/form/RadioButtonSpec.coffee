define [
  'lib/component/Component'
  'lib/component/form/RadioButton'
  'mocks/component/MockedItemView'
], (
  Component
  RadioButton
  MockedItemView
) ->
  'use strict'

  describe 'RadioButton', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"

    TEXT_1 = 'TEXT_1'
    TEXT_2 = 'TEXT_2'

    VALUE_1 = 'VALUE_1'
    VALUE_2 = 'VALUE_2'

    ERROR_MESSAGE_MODEL = 'model needs to be specified'
    ERROR_MESSAGE_COLLECTION = 'collection needs to be specified'
    ERROR_MESSAGE_UNSUPPORTED_METHOD = 'Unsupported Method, use getDomNodes() instead.'

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: null)
      @collection = new Backbone.Collection [
        value: VALUE_1, text: TEXT_1
      , value: VALUE_2, text: TEXT_2
      ]

      @radioButton = new Backbone.Marionette.Component.RadioButton COMPONENT_ID, COMPONENT_PROPERTY, @model, @collection

      @targetNode = $("<input>").attr
        'component-id': COMPONENT_ID
        'name': 'radioGroup'
        'type': 'radio'

      @view = new MockedItemView
      @view.$el.append @targetNode

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of RadioButton', ->
      expect(@radioButton).to.be.an.instanceof Backbone.Marionette.Component.RadioButton
      expect(@radioButton).to.be.an.instanceof Backbone.Marionette.Component.Component
      expect(@radioButton.constructor.name).to.be.equal 'RadioButton'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new Backbone.Marionette.Component.RadioButton()).to.throw ERROR_MESSAGE_MODEL

    it 'should throw an error if no collection is passed', ->
      expect(=> new Backbone.Marionette.Component.RadioButton(COMPONENT_ID, COMPONENT_PROPERTY, @model)).to.throw ERROR_MESSAGE_COLLECTION;

    it 'should throw an error if getDomNode is called', ->
      expect(=> @radioButton.getDomNode()).to.throw ERROR_MESSAGE_UNSUPPORTED_METHOD

    it 'should call render and getDomNodes when rendered', ->
      #given
      @view.add @radioButton

      sinon.spy @radioButton, 'render'
      sinon.spy @radioButton, 'getDomNodes'

      #when
      @view.render()

      #then
      @radioButton.render.should.have.been.calledOnce
      @radioButton.getDomNodes.should.have.been.calledOnce

    it 'should have no selected radio button', ->
      #given
      @view.add @radioButton

      #when
      @view.render()

      #then
      radioButtons = @radioButton.getDomNodes()
      expect($(radioButtons.get(0)).prop('checked')).to.be.false
      expect($(radioButtons.get(1)).prop('checked')).to.be.false

    it 'should select radio button based on model value', ->
      #given
      @view.add @radioButton
      @model.set COMPONENT_PROPERTY, VALUE_1

      #when
      @view.render()

      #then
      radioButtons = @radioButton.getDomNodes()
      expect($(radioButtons.get(0)).prop('checked')).to.be.true
      expect($(radioButtons.get(1)).prop('checked')).to.be.false

