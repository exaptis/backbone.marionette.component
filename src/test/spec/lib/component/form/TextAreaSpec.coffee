define [
  'lib/component/Component'
  'lib/component/form/TextArea'
], (
  Component
  TextArea
) ->
  'use strict'

  describe 'TextArea', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE = "COMPONENT_VALUE"

    before ->
      @viewInstance =
        $: jQuery
        $el: $('#fixture')

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE)
      @textArea = new TextArea COMPONENT_ID, COMPONENT_PROPERTY, @model

      @targetNode = $("<input>").attr 'component-id', COMPONENT_ID
      @viewInstance.$el.append @targetNode

    afterEach ->
      @viewInstance.$el.empty()

    it 'should be an instantce of TextArea', ->
      expect(@textArea).to.be.an.instanceof TextArea
      expect(@textArea).to.be.an.instanceof Component
      expect(@textArea.constructor.name).to.be.equal 'TextArea'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new TextArea()).to.throw(Error);


    it 'should set the component model-value on the dom node', ->
      #given
      @textArea.setViewInstance(@viewInstance)

      #when
      @textArea.render()

      #then
      expect(@textArea.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(@textArea.getDomNode().val()).to.be.equal COMPONENT_VALUE
