define [
  'lib/component/ItemView'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/form/SubmitButton'
  'lib/component/validation/validator/PatternValidator'
  'lib/component/panel/FeedbackPanel'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/PatternValidatorItemViewTemplate'
], (
  ItemView
  Form
  TextField
  SubmitButton
  PatternValidator
  FeedbackPanel
  CodeHighlightBehavior
  MaterializeBehavior
  PatternValidatorItemViewTemplate
) ->
  'use strict'

  class PatternValidatorView extends Backbone.Marionette.Component.ItemView

    template: PatternValidatorItemViewTemplate

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
        phoneNumber: '012-456-'

      # Create components
      form = new Form 'formComponent',
        onSubmit: =>
          @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4
        onError: =>
          @ui.formOutput.text 'Invalid Input'

      # Create components
      phoneNumberComponent = new TextField 'phoneNumberComponent', 'phoneNumber', @personModel
      phoneNumberComponent.add new PatternValidator '^(\([0-9]{3}\)\s*|[0-9]{3}\-)[0-9]{3}-[0-9]{4}$', 'ig'

      phoneNumberFeedbackPanel = new FeedbackPanel 'phoneNumberFeedbackPanel', phoneNumberComponent

      submitButtonComponent = new SubmitButton 'submitButtonComponent'

      # Add components to the form
      form.add phoneNumberComponent
      form.add submitButtonComponent

      # Add components to the view
      @add form
      @add new FeedbackPanel 'phoneNumberFeedbackPanel', phoneNumberComponent

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


