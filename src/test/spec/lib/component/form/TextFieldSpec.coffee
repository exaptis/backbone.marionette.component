define [
  'lib/component/Component'
  'lib/component/form/TextField'
  'mocks/component/MockedItemView'
], (
  Component
  TextField
  MockedItemView
) ->
  'use strict'

  describe 'TextField', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE = "COMPONENT_VALUE"

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE)
      @textField = new Backbone.Marionette.Component.TextField COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr 'component-id', COMPONENT_ID

      @view = new MockedItemView
      @view.$el.append @targetNode

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of TextField', ->
      expect(@textField).to.be.an.instanceof Backbone.Marionette.Component.TextField
      expect(@textField).to.be.an.instanceof Backbone.Marionette.Component.Component
      expect(@textField.constructor.name).to.be.equal 'TextField'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new Backbone.Marionette.Component.TextField()).to.throw(Error);


    it 'should set the component model-value on the dom node', ->
      #given
      @view.add @textField

      #when
      @view.render()

      #then
      expect(@textField.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@textField.getDomNode().val()).to.be.equal COMPONENT_VALUE
