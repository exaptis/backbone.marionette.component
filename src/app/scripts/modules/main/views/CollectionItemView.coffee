define [
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/form/TextField'
  'modules/main/behavior/CodeHighlightBehavior'
  'hbs!/templates/modules/main/views/CollectionItemViewTemplate'
], (
  ItemView
  Label
  TextField
  CodeHighlightBehavior
  ItemViewTemplate
) ->
  'use strict'

  ###
   ItemView
  ###
  class TextFieldItemView extends Backbone.Marionette.Component.ItemView
    template: _.template """
      <input class="form-control" component-id="textfield" placeholder="Name">
      """

    initialize: ->
      @add new TextField('textfield', 'name', @model)

  ###
    CollectionView
  ###
  class TextFieldCollectionView extends Backbone.Marionette.CollectionView
    childView: TextFieldItemView

  ###
   PageView
  ###
  class ComponentItemView extends Backbone.Marionette.ItemView

    template: ItemViewTemplate

    behaviors:
      codeHighlight:
        behaviorClass: CodeHighlightBehavior

    ui:
      content: '#content'

    onRender: ->
      collection = new Backbone.Collection [
        { id:1, name: 'David' }
        { id:2, name: 'Thomas' }
        { id:3, name: 'Markus' }
      ]
      view = new TextFieldCollectionView(collection: collection);
      view.render()
      view.$el.appendTo @ui.content
