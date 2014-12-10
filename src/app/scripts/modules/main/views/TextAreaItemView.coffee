define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/TextArea'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/TextAreaItemViewTemplate'
], (
  ItemView
  Label
  TextArea
  CodeHighlightBehavior
  TextAreaItemViewTemplate
) ->
  'use strict'

  class TextAreaItemView extends Backbone.Marionette.Component.ItemView

    template: TextAreaItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    initialize: ->
      commentModel = new Backbone.Model(comment: 'This is my first comment...')

      @add(new TextArea('textarea1', 'comment', commentModel))
      @add(new Label('label', 'comment', commentModel))
