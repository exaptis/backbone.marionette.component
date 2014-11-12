define [
  'lib/component/adapter/rivets'
], (
  rivets
) ->
  'use strict'

  ## Backbone.Marionette.Component
  ## -----------------------------

  ## Description
  ##
  ##

  instanceCounter = 0

  class Component

    constructor: (@componentId) ->
      unless @componentId
        throw new Error "componentId needs to be specified"

      @componentPrefix = 'component'

      @bindingId = @getNextComponentId()

    setComponentId: (@componentId) ->

    getComponentId: () ->
      @componentId

    setViewInstance: (@viewInstance) ->

    getViewInstance: () ->
      @viewInstance

    getBindingId: ->
      @bindingId

    getBindingPrefix: ->
      "#{@componentPrefix}#{@bindingId}"

    getNextComponentId: () ->
      ++instanceCounter

    getDomNode: () ->
      @viewInstance.$("[component-id='#{@componentId}']")

    initDataBinding: () ->
      data = {}
      data["#{@getBindingPrefix()}"] = @model
      @rivetsView = rivets.bind @viewInstance.$el, data

    render: () ->

    onRender: () ->
      super
