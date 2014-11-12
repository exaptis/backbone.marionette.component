define [
  'lib/component/markup/Label'
  'lib/component/ItemView'
  'hbs!/templates/modules/main/views/LabelItemViewTemplate'
], (
  Label
  ItemView
  LabelItemViewTemplate
) ->
  'use strict'

  class LabelItemView extends Backbone.Marionette.Component.ItemView

    template: LabelItemViewTemplate

    initialize: ->
      @add(new Label("message1", "Hello World"))
      @add(new Label("message2", "message", new Backbone.Model(message: "Hi Human!")))
