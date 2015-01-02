define [
  'lib/component/markup/Label'
  'lib/component/ItemView'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/LabelItemViewTemplate'
], (
  Label
  ItemView
  CodeHighlightBehavior
  MaterializeBehavior
  LabelItemViewTemplate
) ->
  'use strict'

  class LabelItemView extends Backbone.Marionette.Component.ItemView

    template: LabelItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior


    initialize: ->
      @add(new Label("message1", "Hello World"))
      @add(new Label("message2", "message", new Backbone.Model(message: "Hi Human!")))

