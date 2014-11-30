define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/TextField'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/TextFieldItemViewTemplate'
], (
  ItemView
  Label
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
      model = new Backbone.Model(name: 'David')
      @add(new TextField('textfield', 'name', model))
      @add(new Label('textfieldValue', 'name', model))
