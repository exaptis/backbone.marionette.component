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

    constructor: (@componentId, @model) ->
      unless @componentId
        throw new Error "componentId needs to be specified"

      # Generate unique ID
      @cid = 'c' + compentInstanceCounter.incrementCounter()

    setComponentId: (@componentId) ->

    getComponentId: () ->
      @componentId

    setModel: (@model) ->

    getModel: () ->
      @model

    setViewInstance: (@viewInstance) ->

    getViewInstance: () ->
      @viewInstance

    ###
      Retrieve dom node from viewInstance
    ###
    getDomNode: () ->
      @viewInstance.$("[component-id='#{@componentId}']")

    ###
      Return key:value object for data binding
    ###
    getModelData: () ->
      data = {}
      data["#{@cid}"] = @model
      data

    ###
      Binding the model data to the view instance
    ###
    render: () ->
      @rivetsView = rivets.bind @viewInstance.$el, @getModelData()

    ###
      Unbind rivetsView when component is closed
    ###
    close: () ->
      @rivetsView.unbind() if @rivetsView
