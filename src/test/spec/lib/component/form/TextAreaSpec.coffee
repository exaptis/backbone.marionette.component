define [
  'lib/component/Component'
  'lib/component/form/TextArea'
  'mocks/component/MockedItemView'
], (
  Component
  TextArea
  MockedItemView
) ->
  'use strict'

  describe 'TextArea', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE = "COMPONENT_VALUE"

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE)
      @textArea = new Backbone.Marionette.Component.TextArea COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr 'component-id', COMPONENT_ID

      @view = new MockedItemView
      @view.$el.append @targetNode

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of TextArea', ->
      expect(@textArea).to.be.an.instanceof TextArea
      expect(@textArea).to.be.an.instanceof Component
      expect(@textArea.constructor.name).to.be.equal 'TextArea'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new Backbone.Marionette.Component.TextArea()).to.throw(Error);


    it 'should set the component model-value on the dom node', ->
      #given
      @view.add @textArea

      #when
      @view.render()

      #then
      expect(@textArea.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@textArea.getDomNode().val()).to.be.equal COMPONENT_VALUE
