define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/Checkbox'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/CheckboxItemViewTemplate'
], (
  ItemView
  Label
  Checkbox
  CodeHighlightBehavior
  MaterializeBehavior
  CheckboxItemViewTemplate
) ->
  'use strict'

  class CheckboxItemView extends Backbone.Marionette.Component.ItemView

    template: CheckboxItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior


    initialize: ->
      appleModel = new Backbone.Model(isChecked: true)
      orangeModel = new Backbone.Model(isChecked: false)

      @add(new Checkbox('checkboxApple', 'isChecked', appleModel))
      @add(new Checkbox('checkboxOrange', 'isChecked', orangeModel))

      @add(new Label('labelApple', 'isChecked', appleModel))
      @add(new Label('labelOrange', 'isChecked', orangeModel))
