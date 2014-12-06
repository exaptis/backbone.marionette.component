define [
  'lib/component/Component'
  'lib/component/generics/Map'
], (
  Component
  Map
) ->
  'use strict'

  ## Backbone.Marionette.Component.ItemView
  ## ------------------------------------------

  ## Description
  ##
  ##

  class ItemView extends Backbone.Marionette.ItemView

    constructor: () ->
      @_components = new Map
      super

    ###
      Adds a child component to this view
    ###
    add: (components...) ->
      for component in components

        unless component instanceof Component
          throw new Error "#{component.constructor.name} has to be an instance of Component"

        if @_components.has component.getComponentId()
          throw new Error "#{component.getComponentId()} has already been added"

        component.setViewInstance @

        @_components.put component.getComponentId(), component

    contains: (component) ->
      @_components.has component.getComponentId()

    ###
      Binding the model data to the view instance
    ###

    removeComponent: (component) ->
      @_components.remove component.getComponentId()

    ###
      Binding the model data to the view instance
    ###
    onRender: ->
      data = {}

      @_components.each (component) ->
        component.onBeforeRender()

      @_components.each (component) ->
        data = _.extend data, component.getModelData()

      @rivetsView = rivets.bind @$el, data

      @_components.each (component) ->
        component.onAfterRender()

    ###
      Unbind rivetsView when component is closed
    ###
    onClose: () ->
      @rivetsView.unbind() if @rivetsView


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.ItemView or= ItemView
