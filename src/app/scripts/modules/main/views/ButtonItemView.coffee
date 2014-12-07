define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/Button'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/ButtonItemViewTemplate'
], (
  ItemView
  Label
  Button
  CodeHighlightBehavior
  ButtonItemViewTemplate
) ->
  'use strict'

  class ButtonItemView extends Backbone.Marionette.Component.ItemView

    template: ButtonItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    initialize: ->
      @model = new Backbone.Model(counter: 0)

      @add new Button('button', @onButtonClick)
      @add new Label('label', 'counter', @model)

    onButtonClick: (e) ->
      e.preventDefault()
      @model.set 'counter', @model.get('counter') + 1
