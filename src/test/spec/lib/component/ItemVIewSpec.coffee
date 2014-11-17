define [
  'lib/component/ItemView'
  'lib/component/Component'
], (
  ItemView
  Component
) ->
  'use strict'

  describe 'ItemView', ->
    beforeEach ->
      @itemView = new ItemView

    it 'should be an instantce of Component', ->
      expect(@itemView).to.be.an.instanceof ItemView
      expect(@itemView.constructor.name).to.be.equal 'ItemView'

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

    it 'should call render on every component', ->
      #given
      component1 = new Component("componentId1")
      component2 = new Component("componentId2")

      renderSpy1 = sinon.spy component1, 'render'
      renderSpy2 = sinon.spy component2, 'render'

      @itemView.add component1, component2

      #when
      @itemView.onRender()

      #then
      renderSpy1.should.have.been.called
      renderSpy1.should.have.been.calledOnce

      renderSpy2.should.have.been.called
      renderSpy2.should.have.been.calledOnce



