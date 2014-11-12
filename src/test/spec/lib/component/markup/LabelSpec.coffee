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
