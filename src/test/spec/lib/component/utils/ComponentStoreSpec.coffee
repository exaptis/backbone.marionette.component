define [
  'lib/component/Component'
  'lib/component/utils/ComponentStore'
], (
  Component
  ComponentStore
) ->
  'use strict'

  describe 'ComponentStore', ->
    beforeEach ->
      @componentStore = new Backbone.Marionette.Component.ComponentStore

    it 'should be an instance of componentStore', ->
      expect(@componentStore).to.be.an.instanceof Backbone.Marionette.Component.ComponentStore
      expect(@componentStore.constructor.name).to.be.equal 'ComponentStore'

    it 'should add one component to the view', ->
      #given
      component = new Backbone.Marionette.Component.Component("componentId")

      #when
      @componentStore.add(component)

      #then
      expect(@componentStore.contains(component)).to.be.true

    it 'should add multiple components to the view', ->
      #given
      component1 = new Backbone.Marionette.Component.Component("componentId1")
      component2 = new Backbone.Marionette.Component.Component("componentId2")

      #when
      @componentStore.add(component1, component2)

      #then
      expect(@componentStore.contains(component1)).to.be.true
      expect(@componentStore.contains(component2)).to.be.true

    it 'should remove an component from the view', ->
      #given
      component = new Backbone.Marionette.Component.Component("componentId")
      @componentStore.add(component)

      #when
      @componentStore.remove(component)

      #then
      expect(@componentStore.contains(component)).to.be.false

    it 'should throw exception if object added ist not a component', ->
      #given
      objectSpy = sinon.spy()
      errorMessage = "#{objectSpy.constructor.name} has to be an instance of Component"

      #when
      addUnsupportedObject = =>
        @componentStore.add(objectSpy)

      #then
      expect(addUnsupportedObject).to.throw errorMessage

    it 'should throw exception if object is already added', ->
      #given
      component1 = new Backbone.Marionette.Component.Component("componentId1")
      errorMessage = "#{component1.getComponentId()} has already been added"

      #when
      addComponentTwice = =>
        @componentStore.add(component1)
        @componentStore.add(component1)

      #then
      expect(addComponentTwice).to.throw errorMessage

