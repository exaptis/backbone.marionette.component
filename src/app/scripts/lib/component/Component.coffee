define [], () ->
  'use strict'

  ## Backbone.Marionette.Component
  ## -----------------------------

  ## Description
  ##
  ##

  class Component

    constructor: (@componentId) ->
      unless @componentId
        throw new Error "componentId needs to be specified"

    getComponentId: () ->
      @componentId

    setComponentId: (componentId) ->
      @componentId = componentId

    onRender: () ->
      super
