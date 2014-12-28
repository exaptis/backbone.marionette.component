define [
  'lib/component/ItemView'
], (
  ItemView
) ->
  'use strict'

  class MockedItemView extends Backbone.Marionette.Component.ItemView
    template: false
    $el: $('<div>')
