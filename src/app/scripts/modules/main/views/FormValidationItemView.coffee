define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/Form'
  'lib/component/form/TextField'
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
        name: 'A too long name'
        email: 'david-???@gmail.com'

      # Create form and add components
      form = new Form 'formComponent',
        onSubmit: =>
          @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4
        onError: =>
          @ui.formOutput.text 'Invalid Input'

      # Create text component and add validators
      textFieldComponent = new TextField 'nameComponent', 'name', @personModel
      textFieldComponent.add new StringValidator::lengthBetween 2, 5

      # Create email component and add validators
      emailAddressComponent = new TextField 'emailAddressComponent', 'email', @personModel
      emailAddressComponent.add new EmailAddressValidator

      # Add all components to the form
      form.add emailAddressComponent
      form.add textFieldComponent

      # Add components to the page
      @add form

      # Add feedback panels for form validation to the page
      @add new FeedbackPanel 'nameFeedbackPanel', textFieldComponent
      @add new FeedbackPanel 'emailAddressFeedbackPanel', emailAddressComponent

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


