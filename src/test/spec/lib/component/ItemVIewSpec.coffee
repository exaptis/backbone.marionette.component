define [
  'lib/component/ItemView'
  'lib/component/Component'
], (
  ItemView
  Component
) ->
  'use strict'

  describe 'ItemView', ->
    itemView = null

    beforeEach ->
      itemView = new ItemView

    it 'should be an instantce of Component', ->
      expect(itemView).to.be.an.instanceof ItemView
      expect(itemView.constructor.name).to.be.equal 'ItemView'

    it 'should add one component to the view', ->
      #given
      component = new Component("componentId")

      #when
      itemView.add(component)

      #then
      expect(itemView.contains(component)).to.be.true

    it 'should add multiple components to the view', ->
      #given
      component1 = new Component("componentId1")
      component2 = new Component("componentId2")

      #when
      itemView.add(component1, component2)

      #then
      expect(itemView.contains(component1)).to.be.true
      expect(itemView.contains(component2)).to.be.true

    it 'should remove an component from the view', ->
      #given
      component = new Component("componentId")
      itemView.add(component)

      #when
      itemView.remove(component)

      #then
      expect(itemView.contains(component)).to.be.false


