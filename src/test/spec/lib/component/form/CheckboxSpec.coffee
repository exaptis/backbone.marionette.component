define [
  'lib/component/Component'
  'lib/component/form/RadioButton'
], (
  Component
  RadioButton
) ->
  'use strict'

  describe 'RadioButton', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE_TRUE = true
    COMPONENT_VALUE_FALSE = false

    before ->
      @viewInstance =
        $: jQuery
        $el: $('#fixture')

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE_TRUE)
      @radioButton = new RadioButton COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr 'component-id', COMPONENT_ID
      @viewInstance.$el.append @targetNode

    afterEach ->
      @viewInstance.$el.empty()

    it 'should be an instantce of RadioButton', ->
      expect(@radioButton).to.be.an.instanceof RadioButton
      expect(@radioButton).to.be.an.instanceof Component
      expect(@radioButton.constructor.name).to.be.equal 'RadioButton'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new RadioButton()).to.throw(Error);


    it 'should set the checkbox as checked', ->
      #given
      @model.set COMPONENT_PROPERTY, COMPONENT_VALUE_TRUE
      @radioButton.setViewInstance(@viewInstance)

      #when
      @radioButton.render()
      debugger

      #then
      expect(@radioButton.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@radioButton.getDomNode().prop('checked')).to.be.true

    it 'should set the checkbox as unckecked', ->
      #given
      @model.set COMPONENT_PROPERTY, COMPONENT_VALUE_FALSE
      @radioButton.setViewInstance(@viewInstance)

      #when
      @radioButton.render()

      #then
      expect(@radioButton.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@radioButton.getDomNode().prop('checked')).to.be.false
