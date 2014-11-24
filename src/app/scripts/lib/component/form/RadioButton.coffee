define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Markup.RadioButton
  ## ------------------------------------------

  ## Description
  ##
  ##

  class RadioButton extends Component
    defaultInputType = 'radio'

    constructor: (@componentId, @property, @model) ->
      unless @model
        throw new Error "model needs to be specified"

      super @componentId

    beforeRender: () ->
      domNode = @getDomNode()
      domNode.attr('type', defaultInputType)
      domNode.attr('rv-checked', "#{@cid}:#{@property}")


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.RadioButton or= RadioButton
