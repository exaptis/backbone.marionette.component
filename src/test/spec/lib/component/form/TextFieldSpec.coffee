define [
  'lib/component/Component'
  'lib/component/form/TextField'
], (
  Component
  TextField
) ->
  'use strict'

  describe 'TextField', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE = "COMPONENT_VALUE"

    before ->
      @viewInstance =
        $: jQuery
        $el: $('#fixture')

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE)
      @textField = new TextField COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr 'component-id', COMPONENT_ID
      @viewInstance.$el.append @targetNode

    afterEach ->
      @viewInstance.$el.empty()

    it 'should be an instantce of TextField', ->
      expect(@textField).to.be.an.instanceof TextField
      expect(@textField).to.be.an.instanceof Component
      expect(@textField.constructor.name).to.be.equal 'TextField'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new TextField()).to.throw(Error);


    it 'should set the component model-value on the dom node', ->
      #given
      @textField.setViewInstance(@viewInstance)

      #when
      @textField.render()

      #then
      expect(@textField.getDomNode()[0]).to.be.equal @targetNode[0]
#      expect(@textField.getDomNode().val()).to.be.equal COMPONENT_VALUE
