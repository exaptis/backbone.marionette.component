define [
  'lib/component/ItemView'
  'lib/component/form/TextField'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/TextFieldItemViewTemplate'
], (
  ItemView
  TextField
  CodeHighlightBehavior
  TextFieldItemViewTemplate
) ->
  'use strict'

  class TextFieldItemView extends Backbone.Marionette.Component.ItemView

    template: TextFieldItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    initialize: ->
      @add(new TextField('textfield1', 'name', new Backbone.Model(name: 'David')))
