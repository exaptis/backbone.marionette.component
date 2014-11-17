define [
  'lib/component/Component'
  'lib/component/markup/Label'
], (
  Component
  Label
) ->
  'use strict'

  describe 'Label', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"
    COMPONENT_VALUE = "COMPONENT_VALUE"

    before ->
      @viewInstance =
        $: jQuery
        $el: $('#fixture')

    beforeEach ->
      @targetNode = $("<span>").attr 'component-id', COMPONENT_ID
      @viewInstance.$el.append @targetNode

    afterEach ->
      @viewInstance.$el.empty()

    it 'should be an instantce of Label', ->
      label = new Label COMPONENT_ID, COMPONENT_VALUE

      expect(label).to.be.an.instanceof Label
      expect(label).to.be.an.instanceof Component
      expect(label.constructor.name).to.be.equal 'Label'

    it 'should throw an error if no id is passed', ->
      expect(-> new Label()).to.throw(Error);

    it 'should set the component value on the dom node', ->
      #given
      label = new Label COMPONENT_ID, COMPONENT_VALUE

      #when
      label.setViewInstance(@viewInstance)
      label.render()

      #then
      expect(label.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(label.getDomNode().text()).to.be.equal COMPONENT_VALUE


    it 'should set the component model-value on the dom node', ->
      #given
      COMPONENT_MODEL = new Backbone.Model(COMPONENT_PROPERTY: COMPONENT_VALUE)
      label = new Label COMPONENT_ID, COMPONENT_PROPERTY, COMPONENT_MODEL

      #when
      label.setViewInstance(@viewInstance)
      label.render()

      #then
      #      debugger
      expect(label.getDomNode()[0]).to.be.equal @targetNode[0]
      expect(label.getDomNode().text()).to.be.equal COMPONENT_VALUE
