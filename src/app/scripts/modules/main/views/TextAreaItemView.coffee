define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/TextArea'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!/templates/modules/main/views/TextAreaItemViewTemplate'
], (
  ItemView
  Label
  TextArea
  CodeHighlightBehavior
  MaterializeBehavior
  TextAreaItemViewTemplate
) ->
  'use strict'

  class TextAreaItemView extends Backbone.Marionette.Component.ItemView

    template: TextAreaItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior
      materialize:
        behaviorClass: MaterializeBehavior

    initialize: ->
      commentModel = new Backbone.Model(comment: 'This is my first comment...')

      @add(new TextArea('textarea1', 'comment', commentModel))
      @add(new Label('label', 'comment', commentModel))
