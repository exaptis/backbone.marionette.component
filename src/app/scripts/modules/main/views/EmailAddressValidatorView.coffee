define [
  'lib/component/ItemView'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/form/SubmitButton'
  'lib/component/validation/validator/EmailAddressValidator'
  'lib/component/panel/FeedbackPanel'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/EmailAddressValidatorItemViewTemplate'
], (
  ItemView
  Form
  TextField
  SubmitButton
  EmailAddressValidator
  FeedbackPanel
  CodeHighlightBehavior
  MaterializeBehavior
  EmailAddressValidatorItemViewTemplate
) ->
  'use strict'

  class EmailAddressValidatorView extends Backbone.Marionette.Component.ItemView

    template: EmailAddressValidatorItemViewTemplate

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
        email: '!-?-david@gmail.com'

      # Create components
      form = new Form 'formComponent',
        onSubmit: =>
          @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4
        onError: =>
          @ui.formOutput.text 'Invalid Input'

      # Create components
      emailAddressComponent = new TextField 'emailAddressComponent', 'email', @personModel
      emailAddressComponent.add new EmailAddressValidator

      emailAddressFeedbackPanel = new FeedbackPanel 'emailAddressFeedbackPanel', emailAddressComponent

      submitButtonComponent = new SubmitButton 'submitButtonComponent'

      # Add components to the form
      form.add emailAddressComponent
      form.add submitButtonComponent

      # Add components to the view
      @add form
      @add emailAddressFeedbackPanel

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


