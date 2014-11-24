define [
  'lib/component/ItemView'
  'lib/component/form/RadioButton'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/RadioButtonItemViewTemplate'
], (
  ItemView
  RadioButton
  CodeHighlightBehavior
  RadioButtonItemViewTemplate
) ->
  'use strict'

  class RadioButtonItemView extends Backbone.Marionette.Component.ItemView

    template: RadioButtonItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    initialize: ->
      @add(new RadioButton('radioButtonMale', 'isChecked', new Backbone.Model(isChecked: true)))
      @add(new RadioButton('radioButtonFemale', 'isChecked', new Backbone.Model(isChecked: false)))
