define [
  'lib/component/Component'
], (Component) ->
  'use strict'

  describe 'Component', ->
    component = null

    beforeEach ->
      component = new Component

    it 'should be an instantce of Component', ->
      expect(component).to.be.an.instanceof Component
      expect(component.constructor.name).to.be 'Component'

#    describe 'Methods', ->
#      it 'should has an add method', ->
#        expect(component.add).to.be.an.instanceof Function


