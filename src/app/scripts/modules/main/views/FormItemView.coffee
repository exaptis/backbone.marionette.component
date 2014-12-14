define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/Form'
  'lib/component/form/TextField'
  'lib/component/form/TextArea'
  'lib/component/form/Checkbox'
  'lib/component/form/Dropdown'
  'lib/component/form/RadioButton'
  'lib/component/form/Button'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/FormItemViewTemplate'
], (
  ItemView
  Label
  Form
  TextField
  TextArea
  Checkbox
  Dropdown
  RadioButton
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
        gender: 'm'
        salutation: 'mr'
        newsletter: true
        description: ''

      # Initialize gender collection
      genderCollection = new Backbone.Collection [
          value: 'm', text: 'Male'
        ,
          value: 'f', text: 'Female'
      ]

      # Initialize salutation collection
      salutationCollection = new Backbone.Collection [
          value: 'mr', text: 'Mr.'
        ,
          value: 'mrs', text: 'Mrs.'
      ]

      # Create form and add components
      form = new Form('form')

      form.add new TextField 'nameComponent', 'name', @personModel
      form.add new TextField 'emailComponent', 'email', @personModel
      form.add new RadioButton 'genderComponent', 'gender', @personModel, genderCollection
      form.add new Dropdown 'salutationComponent', 'salutation', @personModel, salutationCollection
      form.add new Checkbox 'newsletterComponent', 'newsletter', @personModel
      form.add new TextArea 'descriptionComponent', 'description', @personModel
      form.add new Button 'buttonComponent', @onButtonClick

      @add form

    onButtonClick: (e) ->
      e.preventDefault()
      @ui.formOutput.text JSON.stringify @personModel.toJSON(), null, 4


