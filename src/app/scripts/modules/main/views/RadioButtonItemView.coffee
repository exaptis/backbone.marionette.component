define [
  'lib/component/ItemView'
  'lib/component/form/RadioButton'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!/templates/modules/main/views/RadioButtonItemViewTemplate'
], (
  ItemView
  RadioButton
  CodeHighlightBehavior
  MaterializeBehavior
  RadioButtonItemViewTemplate
) ->
  'use strict'

  class RadioButtonItemView extends Backbone.Marionette.Component.ItemView

    template: RadioButtonItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior

    initialize: ->
      model = new Backbone.Model(gender: 'm')
      collection = new Backbone.Collection([
        value: 'm', text: 'Male'
      , value: 'f', text: 'Female'
      ])

      @add(new RadioButton('radioButtonGender', 'gender', model, collection))
