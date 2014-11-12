define [
  'lib/component/Component'
], (Component) ->
  'use strict'

  describe 'Component', ->
    component = null

    beforeEach ->
      component = new Component 'componentId'

    it 'should be an instantce of Component', ->
      expect(component).to.be.an.instanceof Component
      expect(component.constructor.name).to.be.equal 'Component'

    it 'should throw an error if no Id is provided', ->
      expect(-> new Component()).to.throw(Error)

    it 'should set and get componentId', ->
      #given
      newComponentid = "newComponentid"

      #when
      component.setComponentId(newComponentid)

      #then
      expect(component.getComponentId()).to.be.equal(newComponentid)

    it 'should set and get viewInstance', ->
      #given
      viewInstance = {foo: 'bar'}

      #when
      component.setViewInstance(viewInstance)

      #then
      expect(component.getViewInstance()).to.be.equal(viewInstance)

    it 'should increase bindingId per instance', ->
      #when
      component1 = new Component 'componentId1'
      component2 = new Component 'componentId2'

      #then
      expect(component1.getBindingId() + 1).to.be.equal component2.getBindingId()

    it 'should prefix bindingId for view binding', ->
      #given
      componentId = component.getBindingId()

      #when
      bindingPrefix = component.getBindingPrefix()

      #then
      expect(bindingPrefix).to.be.equal("#{component.componentPrefix}#{componentId}")

    it 'should return the dom node from the view instance based on the component id', ->
      #given
#      viewInstance =
#        $: $("<li>")
      componentId = component.getBindingId()

      #when
      bindingPrefix = component.getBindingPrefix()

      #then
      expect(bindingPrefix).to.be.equal("#{component.componentPrefix}#{componentId}")



