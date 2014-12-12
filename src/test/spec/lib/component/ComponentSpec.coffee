define [
  'lib/component/Component'
], (Component) ->
  'use strict'

  describe 'Component', ->
    beforeEach ->
      @component = new Component 'componentId'
      @viewInstance =
        $: jQuery
        $el: $('<div>')

    it 'should be an instance of Component', ->
      expect(@component).to.be.an.instanceof Component
      expect(@component.constructor.name).to.be.equal 'Component'

    it 'should throw an error if no Id is provided', ->
      expect(-> new Component()).to.throw(Error)

    it 'should set and get componentId', ->
      #given
      newComponentId = "newComponentId"

      #when
      @component.setComponentId(newComponentId)

      #then
      expect(@component.getComponentId()).to.be.equal(newComponentId)

    it 'should set and get viewInstance', ->
      #when
      @component.setViewInstance(@viewInstance)

      #then
      expect(@component.getViewInstance()).to.be.equal(@viewInstance)

    it 'should set and get model', ->
      #given
      model = new Backbone.Model()

      #when
      @component.setModel(model)

      #then
      expect(@component.getModel()).to.be.equal(model)

    it 'should increase bindingId per instance', ->
      #given
      component1 = new Component 'componentId1'
      component2 = new Component 'componentId2'

      #when
      counter1 = parseInt(component1.cid.slice -1) + 1
      counter2 = parseInt(component2.cid.slice -1)

      #then
      expect(counter1).to.be.equal counter2

    it 'should return cid:model object for binding', ->
      #given
      model = new Backbone.Model()
      expectedModelData = {}
      expectedModelData["#{@component.cid}"] = model

      #when
      @component.setModel model

      #then
      expect(@component.getModelData()).to.be.eql expectedModelData


    it 'should throw an error if the element can not be found inside the view', ->
      #given
      @component.setViewInstance(@viewInstance)
      errorMessage = "element with id '#{@component.getComponentId()}' could not be found"

      #when
      getMissingDomNode = =>
        @component.getDomNode()

      #then
      expect(getMissingDomNode).to.throw errorMessage




