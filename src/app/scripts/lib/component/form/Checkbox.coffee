define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.Checkbox
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Checkbox extends Component
    defaultInputType = 'checkbox'

    constructor: (@componentId, @property, @model) ->
      unless @model
        throw new Error "model needs to be specified"

      super @componentId

    render: () ->
      domNode = @getDomNode()
      domNode.attr('type', defaultInputType)
      domNode.attr('rv-checked', "#{@cid}:#{@property}")


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Checkbox or= Checkbox
