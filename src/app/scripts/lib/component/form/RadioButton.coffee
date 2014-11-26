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

      ITEM_NAME = 'radio'

      repeatingElement = $('<div>')
      repeatingElement.attr('class','radio')
      repeatingElement.attr("rv-each-#{ITEM_NAME}","#{@cid}.values")

      labelNode = $('<label>')

      optionNode = @getDomNode()
      optionNode.attr('type', defaultInputType)
      optionNode.attr('rv-value', ITEM_NAME)
      optionNode.attr('rv-checked', "#{@cid}:#{@property}")

      textNode = $('<div>')
      textNode.attr('rv-text', "radio")

      optionNode.wrap(labelNode)
      optionNode.parent().wrap(repeatingElement)


      textNode.insertAfter(optionNode)

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.RadioButton or= RadioButton
