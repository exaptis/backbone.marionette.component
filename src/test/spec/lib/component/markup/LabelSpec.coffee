define [
  'lib/component/Component'
  'lib/component/markup/Label'
], (
  Component
  Label
) ->
  'use strict'

  describe 'Label', ->
    label = null

    beforeEach ->
      label = new Label "componentId"

    it 'should be an instantce of Label', ->
      expect(label).to.be.an.instanceof Label
      expect(label).to.be.an.instanceof Component
      expect(label.constructor.name).to.be.equal 'Label'

    it 'should throw an error if no id is passed', ->
      expect(-> new Label()).to.throw(Error);

    it 'should set the component value on the dom node', ->
      #given
      COMPONENT_ID = "COMPONENT_ID"
      COMPONENT_VALUE = "COMPONENT_VALUE"

      label = new Label COMPONENT_ID, COMPONENT_VALUE

      targetNode = $("<span>").attr 'component-id', COMPONENT_ID
      viewInstance =
        $: ->
          targetNode

      #when
      label.setViewInstance(viewInstance)
      label.render()

      #then
      expect(label.getDomNode()).to.be.equal targetNode
      expect(label.getDomNode().text()).to.be.equal COMPONENT_VALUE


    it 'should set the component model-value on the dom node', ->
      #given
      COMPONENT_ID = "COMPONENT_ID"
      COMPONENT_PROPPERTY = "COMPONENT_PROPERTY"
      COMPONENT_VALUE = "COMPONENT_VALUE"
      COMPONENT_MODEL = new Backbone.Model(COMPONENT_MODEL: COMPONENT_VALUE)

      label = new Label COMPONENT_ID, COMPONENT_VALUE

      targetNode = $("<span>").attr 'component-id', COMPONENT_ID
      viewInstance =
        $: ->
          targetNode

      #when
      label.setViewInstance(viewInstance)
      label.render()

      #then
      expect(label.getDomNode()).to.be.equal targetNode
      expect(label.getDomNode().text()).to.be.equal COMPONENT_VALUE
