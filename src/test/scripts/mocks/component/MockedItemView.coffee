define [
  'lib/component/ItemView'
], (
  ItemView
) ->
  'use strict'

  class MockedItemView extends ItemView
    template: false
    el: '#fixture'
    $el: $('#fixture')
