define [
  'lib/component/utils/ComponentStore'
], (
  ComponentStore
) ->
  'use strict'

  class MockedComponentStore extends ComponentStore

    constructor: ->
      super

      sinon.spy @, 'add'
      sinon.spy @, 'remove'
      sinon.spy @, 'contains'
