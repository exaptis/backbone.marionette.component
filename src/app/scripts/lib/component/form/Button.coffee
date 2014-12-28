define [
  'lib/component/Component'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.Form.Button
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Button extends Backbone.Marionette.Component.Component

    constructor: (@componentId, @callback) ->
      unless @callback
        throw new Error "no callback specified"

      super @componentId

    render: () ->
      @getDomNode().on 'click', (event) =>
        @callback.call(@viewInstance, event)

    close: () ->
      @getDomNode().off 'click'

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Button or= Button
