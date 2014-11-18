define [
  'lib/component/ItemView'
  'lib/component/form/TextArea'
  'hbs!/templates/modules/main/views/TextAreaItemViewTemplate'
], (
  ItemView
  TextArea
  TextAreaItemViewTemplate
) ->
  'use strict'

  class TextAreaItemView extends Backbone.Marionette.Component.ItemView

    template: TextAreaItemViewTemplate

    initialize: ->
      @add(new TextArea('textarea1', 'comment', new Backbone.Model(comment: 'This is my first comment...')))

    onShow: ->
      @$el.find('code').each (index, element) ->
        Prism.highlightElement element
