define [
  'lib/component/ItemView'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/validation/validator/StringValidator'
  'lib/component/panel/FeedbackPanel'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/StringValidatorItemViewTemplate'
], (
  ItemView
  Form
  TextField
  StringValidator
  FeedbackPanel
  CodeHighlightBehavior
  MaterializeBehavior
  StringValidatorItemViewTemplate
) ->
  'use strict'

  class StringValidatorView extends Backbone.Marionette.Component.ItemView

    template: StringValidatorItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior

    ui:
      formOutput: '#formOutput'

    initialize: ->
      # Initialize model
      @personModel = new Backbone.Model
        name: 'Maximilian'

      # Create components
      form = new Form 'formComponent',
        onSubmit: =>
          @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4
        onError: =>
          @ui.formOutput.text 'Invalid Input'

      nameComponent = new TextField 'nameComponent', 'name', @personModel
      nameComponent.add new StringValidator::lengthBetween 2, 8

      nameComponentFeedbackPanel = new FeedbackPanel 'feedbackPanel', nameComponent

      # Add components to the form
      form.add nameComponent

      # Add components to the page
      @add form
      @add nameComponentFeedbackPanel

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


