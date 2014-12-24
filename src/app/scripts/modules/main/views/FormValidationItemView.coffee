define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/form/SubmitButton'
  'lib/component/validation/validator/StringValidator'
  'lib/component/validation/validator/EmailAddressValidator'
  'lib/component/panel/FeedbackPanel'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/FormValidationItemViewTemplate'
], (
  ItemView
  Label
  Form
  TextField
  SubmitButton
  StringValidator
  EmailAddressValidator
  FeedbackPanel
  CodeHighlightBehavior
  MaterializeBehavior
  FormValidationItemViewTemplate
) ->
  'use strict'

  class FormItemView extends Backbone.Marionette.Component.ItemView

    template: FormValidationItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior

    ui:
      formOutput: '#formOutput'

    initialize: ->
      # Initialize person model
      @personModel = new Backbone.Model
        name: 'David'
        email: 'david@gmail.com'

      # Create form and add components
      form = new Form 'formComponent',
        onSubmit: =>
          @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4
        onError: ->
          console.log 'error'

      textFieldComponent = new TextField 'nameComponent', 'name', @personModel
      textFieldComponent.add new StringValidator::minimumLength 2
      textFieldComponent.add new StringValidator::maximumLength 5
      @add new FeedbackPanel 'nameFeedbackPanel', textFieldComponent
      form.add textFieldComponent

      emailComponent = new TextField 'emailComponent', 'email', @personModel
      emailComponent.add new EmailAddressValidator
      @add new FeedbackPanel 'emailFeedbackPanel', emailComponent
      form.add emailComponent

      form.add new SubmitButton 'submitButtonComponent'
      @add form

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


