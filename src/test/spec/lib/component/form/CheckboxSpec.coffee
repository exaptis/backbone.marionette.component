define [
  'lib/component/Component'
  'lib/component/form/Checkbox'
  'mocks/component/MockedItemView'
], (
  Component
  Checkbox
  MockedItemView
) ->
  'use strict'

  describe 'Checkbox', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE_TRUE = true
    COMPONENT_VALUE_FALSE = false

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE_TRUE)
      @checkbox = new Checkbox COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr
        'component-id': COMPONENT_ID
        'type': 'checkbox'

      @view = new MockedItemView
      @view.$el.append @targetNode

    afterEach ->
      @view.$el.empty()

    it 'should be an instantce of Checkbox', ->
      expect(@checkbox).to.be.an.instanceof Checkbox
      expect(@checkbox).to.be.an.instanceof Component
      expect(@checkbox.constructor.name).to.be.equal 'Checkbox'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new Checkbox()).to.throw(Error);

    it 'should set the checkbox as checked', ->
      #given
      @model.set COMPONENT_PROPERTY, COMPONENT_VALUE_TRUE
      @view.add @checkbox

      #when
      @view.render()

      #then
      expect(@checkbox.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@checkbox.getDomNode().prop('checked')).to.be.true

    it 'should set the checkbox as unckecked', ->
      #given
      @model.set COMPONENT_PROPERTY, COMPONENT_VALUE_FALSE
      @view.add @checkbox

      #when
      @view.render()

      #then
      expect(@checkbox.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@checkbox.getDomNode().prop('checked')).to.be.false
