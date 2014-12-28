define [
  'lib/component/Component'
  'lib/component/panel/FeedbackPanel'
  'lib/component/validation/ValidationError'
  'mocks/component/MockedItemView'
], (
  Component
  FeedbackPanel
  ValidationError
  MockedItemView
) ->
  'use strict'

  describe 'Panel', ->

    COMPONENT_ID = "COMPONENT_ID"

    beforeEach ->
      @panel = new Backbone.Marionette.Component.FeedbackPanel COMPONENT_ID
      @panelNode = $('<div>').attr 'component-id', COMPONENT_ID

      @collection = new Backbone.Collection [
        id: 1, errorMessage: 'errorMessage1'
      ,
        id: 2, errorMessage: 'errorMessage2'
      ]

      @validationError = new ValidationError [],
        validatorName: 'VALIDATOR_NAME'
        componentId: COMPONENT_ID

      @view = new MockedItemView
      @view.$el.append @panelNode
      @view.add @panel

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of Component', ->
      @panel.should.be.an.instanceof Component
      @panel.constructor.name.should.be.equal 'FeedbackPanel'

    it 'should render feedback panel', ->
      #given
      @panel.setFeedbackList @collection

      #when
      @view.render()

      #then
      @panel.getDomNode().find('li').length.should.be.equal @collection.length

    it 'should remove feedback panel on destroy', ->
      #given
      @panel.setFeedbackList @collection

      #when
      @panel.destroy()

      #then
      expect(@panel._feedbackList).to.be.undefined

    it 'should match components with the same id', ->
      #given
      @panel.filter = getComponentId: -> COMPONENT_ID

      #then
      @panel.componentFilter(@validationError).should.be.true

    it 'should not match components with other ids', ->
      #given
      @panel.filter = getComponentId: -> 'UNKNOWN_COMPONENT_ID'

      #then
      @panel.componentFilter(@validationError).should.be.false
