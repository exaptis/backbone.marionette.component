define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.RadioButton
  ## ------------------------------------------

  ## Description
  ##
  ##

  class RadioButton extends Component
    defaultInputType = 'radio'

    constructor: (@componentId, @property, @model, @collection) ->
      unless @model
        throw new Error 'model needs to be specified'

      unless @collection
        throw new Error 'collection needs to be specified'

      super @componentId

    beforeRender: () ->
      ITEM_NAME = 'radio'

      repeatingElement = $('<div>')
      repeatingElement.attr('class', 'radio')
      repeatingElement.attr("rv-each-#{ITEM_NAME}", "collection#{@cid}.models")

      labelNode = $('<label>')

      optionNode = @getDomNodes()
      optionNode.attr('type', defaultInputType)
      optionNode.attr('rv-value', "#{ITEM_NAME}:value")
      optionNode.attr('rv-checked', "model#{@cid}:#{@property}")

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
      Component::getDomNode.call(@, arguments)

    ###
      Unsupported for this component, as more than one dom node can be returned.
    ###
    getDomNode: () ->
      throw new Error 'Unsupported Method, use getDomNodes() instead.'


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.RadioButton or= RadioButton
