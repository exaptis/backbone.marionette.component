define [
  'mocks/component/MockedItemView'
  'lib/component/Component'
], (
  MockedItemView
  Component
) ->
  'use strict'

  describe 'ItemView', ->

    beforeEach ->
      @itemView = new MockedItemView

    it 'should be an instance of Component', ->
      expect(@itemView).to.be.an.instanceof Backbone.Marionette.ItemView

    it 'should add one component to the view', ->
      #given
      component = new Component("componentId")

      #when
      @itemView.add(component)

      #then
      expect(@itemView.contains(component)).to.be.true

    it 'should add multiple components to the view', ->
      #given
      component1 = new Component("componentId1")
      component2 = new Component("componentId2")

      #when
      @itemView.add(component1, component2)

      #then
      expect(@itemView.contains(component1)).to.be.true
      expect(@itemView.contains(component2)).to.be.true

    it 'should remove an component from the view', ->
      #given
      component = new Component("componentId")
      @itemView.add(component)

      #when
      @itemView.removeComponent(component)

      #then
      expect(@itemView.contains(component)).to.be.false

    it 'should throw exception if object added ist not a component', ->
      #given
      objectSpy = sinon.spy()
      errorMessage = "#{objectSpy.constructor.name} has to be an instance of Component"

      #when
      addUnsupportedObject = =>
        @itemView.add(objectSpy)

      #then
      expect(addUnsupportedObject).to.throw errorMessage

    it 'should throw exception if object is already added', ->
      #given
      component1 = new Component("componentId1")
      errorMessage = "#{component1.getComponentId()} has already been added"

      #when
      addComponentTwice = =>
        @itemView.add(component1)
        @itemView.add(component1)

      #then
      expect(addComponentTwice).to.throw errorMessage

    it 'should call getModelData on every component', ->
      #given
      component1 = new Component("componentId1")
      component2 = new Component("componentId2")

      sinon.spy component1, 'getModelData'
      sinon.spy component2, 'getModelData'

      @itemView.add component1, component2

      #when
      @itemView.render()

      #then
      component1.getModelData.should.have.been.calledOnce
      component2.getModelData.should.have.been.calledOnce

    it 'should call render on component when render is called', ->
      #given
      component = new Component("componentId")
      sinon.spy component, 'render'

      @itemView.add component

      #when
      @itemView.render()

      #then
      component.render.should.have.been.calledOnce


    it 'should call destroy on every component', ->
      #given
      component = new Component("componentId")
      @itemView.add component

      sinon.spy component, 'destroy'

      #when
      @itemView.destroy()

      #then
      component.destroy.should.have.been.calledOnce

    it 'should unbind rivetsView on close', ->
      #given
      component = new Component("componentId")
      @itemView.add component
      @itemView.render()

      sinon.spy @itemView.rivetsView, 'unbind'

      #when
      @itemView.close()

      #then
      @itemView.rivetsView.unbind.should.have.been.calledOnce

