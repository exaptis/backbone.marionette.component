define [
  'lib/component/ItemView'
  'lib/component/form/Checkbox'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!/templates/modules/main/views/CheckboxItemViewTemplate'
], (
  ItemView
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
      @add(new Checkbox('checkboxApple', 'isChecked', new Backbone.Model(isChecked: true)))
      @add(new Checkbox('checkboxOrange', 'isChecked', new Backbone.Model(isChecked: false)))
