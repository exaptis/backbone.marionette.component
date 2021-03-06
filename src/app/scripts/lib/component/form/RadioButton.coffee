define [
  'lib/component/Component'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.Form.RadioButton
  ## ------------------------------------------

  ## Description
  ##
  ##

  class RadioButton extends Backbone.Marionette.Component.Component
    defaultInputType = 'radio'

    constructor: (@componentId, @property, @model, @collection) ->
      unless @model
        throw new Error 'model needs to be specified'

      unless @collection
        throw new Error 'collection needs to be specified'

      super @componentId

    render: () ->
      ITEM_NAME = 'radio'

      labelNode = $('<label>')

      optionNode = @getDomNodes()
      optionNode.attr('type', defaultInputType)
      optionNode.attr('rv-value', "#{ITEM_NAME}:value")
      optionNode.attr('rv-checked', "model#{@cid}:#{@property}")

      repeatingElement = $('<div>')
      repeatingElement.attr('class', optionNode.parent().attr('class'))
      repeatingElement.attr("rv-each-#{ITEM_NAME}", "collection#{@cid}:models")

      optionNode.parent().attr('class','')

      textNode = $('<div>')
      textNode.attr('rv-text', "#{ITEM_NAME}:text")

      optionNode.wrap(labelNode)
      optionNode.parent().wrap(repeatingElement)

      textNode.insertAfter(optionNode)

    getModelData: () ->
      data = {}
      data["model#{@cid}"] = @model
      data["collection#{@cid}"] = @collection
      data

    ###
      Return the option dom elements
    ###
    getDomNodes: () ->
      Backbone.Marionette.Component.Component::getDomNode.call(@, arguments)

    ###
      Unsupported for this component, as more than one dom node can be returned.
    ###
    getDomNode: () ->
      throw new Error 'Unsupported Method, use getDomNodes() instead.'

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.RadioButton or= RadioButton
