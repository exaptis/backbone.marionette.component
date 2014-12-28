define [
  'lib/component/Component'
  'lib/component/Form'
  'lib/component/form/Button'
  'lib/component/form/SubmitButton'
  'mocks/component/MockedItemView'
], (
  Component
  Form
  Button
  SubmitButton
  MockedItemView
) ->
  'use strict'

  describe 'SubmitButton', ->
    BUTTON_COMPONENT_ID = "BUTTON_COMPONENT_ID"
    FORM_COMPONENT_ID = "FORM_COMPONENT_ID"

    beforeEach ->
      @button = new Backbone.Marionette.Component.SubmitButton BUTTON_COMPONENT_ID
      @form = new Backbone.Marionette.Component.Form FORM_COMPONENT_ID
      @form.add @button

      @buttonNode = $("<button>").attr 'component-id', BUTTON_COMPONENT_ID
      @formNode = $("<form>").attr 'component-id', FORM_COMPONENT_ID
      @targetNode = $('<div>').append(@buttonNode).append(@formNode)

      @view = new MockedItemView
      @view.$el.append @targetNode
      @view.add @form

    afterEach ->
      @view.$el.empty()

    it 'should be an instance of Button', ->
      expect(@button).to.be.an.instanceof Button
      expect(@button).to.be.an.instanceof Component
      expect(@button.constructor.name).to.be.equal 'SubmitButton'

    it 'should trigger form process on click', ->
      #given
      sinon.stub @form, 'process', -> true
      @view.render()

      #when
      @button.getDomNode().trigger 'click'

      #then
      @form.process.should.have.been.calledOnce
