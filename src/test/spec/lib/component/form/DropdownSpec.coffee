define [
  'lib/component/Component'
  'lib/component/form/Dropdown'
  'mocks/component/MockedItemView'
], (
  Component
  Dropdown
  MockedItemView
) ->
  'use strict'

  describe 'Dropdown', ->
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
      @model = new Backbone.Model COMPONENT_PROPERTY: null
      @collection = new Backbone.Collection [
        value: VALUE_1, text: TEXT_1
      ,
        value: VALUE_2, text: TEXT_2
      ]

      @select = new Backbone.Marionette.Component.Dropdown COMPONENT_ID, COMPONENT_PROPERTY, @model, @collection

      @targetNode = $("<select>").attr
        'component-id': COMPONENT_ID
        'multiple': 'multiple'

      @view = new MockedItemView
      @view.$el.append @targetNode

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of Dropdown', ->
      expect(@select).to.be.an.instanceof Backbone.Marionette.Component.Dropdown
      expect(@select).to.be.an.instanceof Backbone.Marionette.Component.Component
      expect(@select.constructor.name).to.be.equal 'Dropdown'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new Backbone.Marionette.Component.Dropdown()).to.throw ERROR_MESSAGE_MODEL

    it 'should throw an error if no collection is passed', ->
      expect(=> new Backbone.Marionette.Component.Dropdown(COMPONENT_ID, COMPONENT_PROPERTY, @model)).to.throw ERROR_MESSAGE_COLLECTION;

    it 'should throw an error if getDomNode is called', ->
      expect(=> @select.getDomNode()).to.throw ERROR_MESSAGE_UNSUPPORTED_METHOD

    it 'should call render and getDomNodes when rendered', ->
      #given
      @view.add @select

      sinon.spy @select, 'render'
      sinon.spy @select, 'getDomNodes'

      #when
      @view.render()

      #then
      @select.render.should.have.been.calledOnce
      @select.getDomNodes.should.have.been.calledOnce

    it 'should render the options from the collection', ->
      #given
      @view.add @select

      #when
      @view.render()

      #then
      options = @select.getDomNodes().children('option')

      expect($(options.eq(0)).val()).to.be.equal VALUE_1
      expect($(options.eq(0)).text()).to.be.equal TEXT_1

      expect($(options.eq(1)).val()).to.be.equal VALUE_2
      expect($(options.eq(1)).text()).to.be.equal TEXT_2

    it 'should have no selected radio button', ->
      #given
      @view.add @select

      #when
      @view.render()

      #then
      expect(@select.getDomNodes().val()).to.be.equal null

    it 'should select value based on model value', ->
      #given
      @view.add @select
      @model.set COMPONENT_PROPERTY, [VALUE_1]

      #when
      @view.render()

      #then
      expect(@select.getDomNodes().val()).to.be.eql [VALUE_1]

