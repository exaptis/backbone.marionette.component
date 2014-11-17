define [
  'lib/component/markup/Label'
  'lib/component/ItemView'
  'hbs!/templates/modules/main/views/LabelItemViewTemplate'
  'prism'
], (
  Label
  ItemView
  LabelItemViewTemplate
  Prism
) ->
  'use strict'

  class LabelItemView extends Backbone.Marionette.Component.ItemView

    template: LabelItemViewTemplate

    initialize: ->
      @add(new Label("message1", "Hello World"))
      @add(new Label("message2", "message", new Backbone.Model(message: "Hi Human!")))

    onShow: ->
      @$el.find('code').each (index, element) ->
        Prism.highlightElement element


