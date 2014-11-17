define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Markup.TextField
  ## ------------------------------------------

  ## Description
  ##
  ##

  class TextField extends Component
    defaultInputType = 'text'

    constructor: (@componentId, @property, @model) ->
      unless @model
        throw new Error "model needs to be specified"

      super @componentId, @model

    beforeRender: () ->
      domNode = @getDomNode()

      unless domNode.attr('type')
        domNode.attr('type', @inputType or defaultInputType)

      domNode.attr('rv-value', "#{@cid}:#{@property}")


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.TextField or= TextField
