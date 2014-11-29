define [
  'lib/component/ItemView'
  'lib/component/form/Dropdown'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!/templates/modules/main/views/DropdownItemViewTemplate'
], (
  ItemView
  Dropdown
  CodeHighlightBehavior
  MaterializeBehavior
  DropdownItemViewTemplate
) ->
  'use strict'

  class DropdownItemView extends Backbone.Marionette.Component.ItemView

    template: DropdownItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior

    initialize: ->
      model = new Backbone.Model(fruit: '2')
      collection = new Backbone.Collection [
        value: '1', text: 'Orange'
      ,
        value: '2', text: 'Apple'
      ,
        value: '3', text: 'Banana'
      ]

      @add(new Dropdown('fruitChoice', 'fruit', model, collection))
