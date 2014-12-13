define [
  'lib/component/Component'
  'lib/component/utils/ComponentStore'
  'lib/component/adapter/rivets'
], (
  Component
  ComponentStore
  rivets
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form
  ## ----------------------------------

  ## Description
  ##
  ##

  class Form extends Component

    constructor: () ->
      @_componentStore = new ComponentStore
      super

    add: (components...) ->
      @_componentStore.add.apply @_componentStore, components

    contains: (component) ->
      @_componentStore.contains.call @_componentStore, component

    remove: (component) ->
      @_componentStore.remove.call @_componentStore, component

    onBeforeAdded: ->
      @_componentStore.each (component) ->
        component.onBeforeAdded()

    onAfterAdded: ->
      @_componentStore.each (component) ->
        component.onAfterAdded()

    onBeforeRender: ->
      @_componentStore.each (component) ->
        component.onBeforeRender()

    onAfterRender: ->
      @_componentStore.each (component) ->
        component.onAfterRender()

    onBeforeClose: ->
      @_componentStore.each (component) ->
        component.onBeforeClose()

    onAfterClose: ->
      @_componentStore.each (component) ->
        component.onAfterClose()

    setViewInstance: (viewInstance) ->
      super

      @_componentStore.each (component) ->
        component.setViewInstance viewInstance

    getModelData: ->
      data = {}

      @_componentStore.each (component) ->
        data = _.extend data, component.getModelData()

      return data


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Form or= Form
