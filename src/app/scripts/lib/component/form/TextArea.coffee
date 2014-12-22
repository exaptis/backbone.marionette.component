define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.TextArea
  ## ------------------------------------------

  ## Description
  ##
  ##

  class TextArea extends Component
    constructor: (@componentId, @property, @model) ->
      unless @model
        throw new Error "model needs to be specified"

      super @componentId, @model

    render: () ->
      domNode = @getDomNode()
      domNode.attr('rv-value', "#{@cid}:#{@property}")


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.TextArea or= TextArea
