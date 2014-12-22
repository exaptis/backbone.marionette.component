define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/form/Button'
  'lib/component/validation/validators/StringValidator'
  'lib/component/validation/validators/EmailAddressValidator'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/FormItemViewTemplate'
], (
  ItemView
  Label
  Form
  TextField
  StringValidator
  EmailAddressValidator
  Button
  CodeHighlightBehavior
  MaterializeBehavior
  FormItemViewTemplate
) ->
  'use strict'

  class FormItemView extends Backbone.Marionette.Component.ItemView

    template: FormItemViewTemplate

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
      form = new Form('form')

      textFieldComponent = new TextField 'nameComponent', 'name', @personModel
      textFieldComponent.add new StringValidator.minimumLength 2

      emailComponent = new TextField 'emailComponent', 'email', @personModel
      emailComponent.add new EmailAddressValidator

      form.add new Button 'buttonComponent', @onButtonClick

      @add form

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


