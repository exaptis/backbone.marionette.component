define [
  'lib/component/adapter/rivets'
  'lib/component/utils/InstanceCounter'
], (
  rivets
  InstanceCounter
) ->
  'use strict'

  ## Backbone.Marionette.Component
  ## -----------------------------

  ## Description
  ##
  ##

  class Component

    ###
     Private instance counter for generating unique ids
    ###
    compentInstanceCounter = new InstanceCounter

    constructor: (@componentId) ->
      unless @componentId
        throw new Error "componentId needs to be specified"

      # Generate unique ID
      @cid = 'c' + compentInstanceCounter.incrementCounter()

    setComponentId: (@componentId) ->

    getComponentId: () -> @componentId

    setModel: (@model) ->

    getModel: () -> @model

    setProperty: (@property) ->

    getProperty: () -> @property

    getValue: () -> @model.get @property

    setViewInstance: (@viewInstance) ->

    getViewInstance: () -> @viewInstance

    ###
      Retrieve dom node from viewInstance
    ###
    getDomNode: () ->
      domNode = @viewInstance.$("[component-id='#{@componentId}']")

      unless domNode.length
        throw new Error "element with id '#{@componentId}' could not be found"

      domNode

    ###
      Return key:value object for data binding
    ###
    getModelData: () ->
      data = {}
      data["#{@cid}"] = @model
      data

    ###
      Called before the component is added
    ###
    onBeforeAdded: ->

    ###
      Called after the component is added
    ###
    onAfterAdded: ->

    ###
      Called before the component is rendered
    ###
    onBeforeRender: ->

    ###
      Called after the component is rendered
    ###
    onAfterRender: ->

    ###
     Called before the component is closed
    ###
    onBeforeClose: ->

    ###
      Called after the component is closed
    ###
    onAfterClose: ->

