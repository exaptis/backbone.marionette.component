define [
  'lib/component/Component'
  'lib/component/generics/Map'
], (
  Component
  Map
) ->
  'use strict'

  class ComponentStore

    constructor: () ->
      @_components = new Map

    ###
      Adds a component to the storage
    ###
    add: (components...) ->
      for component in components
        unless component instanceof Component
          throw new Error "#{component.constructor.name} has to be an instance of Component"

        if @_components.has component.getComponentId()
          throw new Error "#{component.getComponentId()} has already been added"

        @_components.put component.getComponentId(), component

    ###
      Removes a component from the storage
    ###
    remove: (component) ->
      @_components.remove component.getComponentId()

    contains: (component) ->
      @_components.has component.getComponentId()

    each: (callback) ->
      @_components.each (component) ->
        callback.call(@, component)
