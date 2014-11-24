define [
  'lib/component/ItemView'
  'lib/component/form/Checkbox'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/CheckboxItemViewTemplate'
], (
  ItemView
  Checkbox
  CodeHighlightBehavior
  CheckboxItemViewTemplate
) ->
  'use strict'

  class CheckboxItemView extends Backbone.Marionette.Component.ItemView

    template: CheckboxItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    initialize: ->
      @add(new Checkbox('checkboxApple', 'isChecked', new Backbone.Model(isChecked: true)))
      @add(new Checkbox('checkboxOrange', 'isChecked', new Backbone.Model(isChecked: false)))
