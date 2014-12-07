define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.Button
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Button extends Component
    defaultInputType = 'checkbox'

    constructor: (@componentId, @callback) ->
      unless @callback
        throw new Error "no callback specified"

      super @componentId

    onBeforeRender: () ->
      @getDomNode().on 'click', (event) =>
        @callback.call(@viewInstance, event)

    onBeforeClose: () ->
      @getDomNode().off 'click'


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Button or= Button
