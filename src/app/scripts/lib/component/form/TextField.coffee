define [
  'lib/component/Component'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.Form.TextField
  ## ------------------------------------------

  ## Description
  ##
  ##

  class TextField extends Backbone.Marionette.Component.Component
    defaultInputType = 'text'

    constructor: (@componentId, @property, @model) ->
      unless @model
        throw new Error "model needs to be specified"

      super @componentId, @model

    render: () ->
      domNode = @getDomNode()

      unless domNode.attr('type')
        domNode.attr('type', @inputType or defaultInputType)

      domNode.attr('rv-value', "#{@cid}:#{@property}")

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.TextField or= TextField
