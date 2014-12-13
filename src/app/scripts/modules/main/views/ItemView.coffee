define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/TextField'
  'modules/main/behavior/CodeHighlightBehavior'
  'modules/main/behavior/MaterializeBehavior'
  'hbs!/templates/modules/main/views/ItemViewTemplate'
], (
  ItemView
  Label
  TextField
  CodeHighlightBehavior
  MaterializeBehavior
  ItemViewTemplate
) ->
  'use strict'

  class TextFieldItemView extends Backbone.Marionette.Component.ItemView
    template: _.template """
      <input class="form-control" component-id="textfield" placeholder="Name">
      """

    initialize: ->
      @add new TextField('textfield', 'name', @model)

  class ComponentItemView extends Backbone.Marionette.ItemView

    template: ItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior


    ui:
      content: '#content'

    onRender: ->
      model = new Backbone.Model(name: 'David')
      view = new TextFieldItemView(model: model)
      view.render()
      view.$el.appendTo @ui.content


