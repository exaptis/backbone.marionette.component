define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  class MockedComponent extends Backbone.Marionette.Component.Component

    constructor: ->
      super
      sinon.spy @, 'add'

