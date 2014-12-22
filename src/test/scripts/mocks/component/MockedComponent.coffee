define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  class MockedComponent extends Component

    constructor: ->
      super
      sinon.spy @, 'add'

