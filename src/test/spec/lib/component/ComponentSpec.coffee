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


