define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.Dropdown
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Dropdown extends Component

    constructor: (@componentId, @property, @model, @collection) ->
      unless @model
        throw new Error 'model needs to be specified'

      unless @collection
        throw new Error 'collection needs to be specified'

      super @componentId

    onBeforeRender: () ->
      ITEM_NAME = 'option'

      optionNode = $('<option>')
      optionNode.attr("rv-each-#{ITEM_NAME}", "collection#{@cid}.models")
      optionNode.attr('rv-value', "#{ITEM_NAME}:value")
      optionNode.attr('rv-text', "#{ITEM_NAME}:text")

      selectNode = @getDomNodes()
      selectNode.attr('rv-value', "model#{@cid}:#{@property}")
      selectNode.append(optionNode)

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
  Backbone.Marionette.Component.Dropdown or= Dropdown
