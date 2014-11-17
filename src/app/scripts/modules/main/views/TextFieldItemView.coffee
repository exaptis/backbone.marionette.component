define [
  'lib/component/ItemView'
  'lib/component/form/TextField'
  'hbs!/templates/modules/main/views/TextFieldItemViewTemplate'
], (
  ItemView
  TextField
  TextFieldItemViewTemplate
) ->
  'use strict'

  class TextFieldItemView extends Backbone.Marionette.Component.ItemView

    template: TextFieldItemViewTemplate

    initialize: ->
      @add(new TextField('textfield1', 'name', new Backbone.Model(name: 'David')))

    onShow: ->
      @$el.find('code').each (index, element) ->
        Prism.highlightElement element
