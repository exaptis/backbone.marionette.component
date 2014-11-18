define [
  'lib/component/ItemView'
  'lib/component/form/TextArea'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/TextAreaItemViewTemplate'
], (
  ItemView
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
      @add(new TextArea('textarea1', 'comment', new Backbone.Model(comment: 'This is my first comment...')))
