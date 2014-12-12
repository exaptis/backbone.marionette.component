define [
  'lib/component/utils/ComponentStore'
  'lib/component/adapter/rivets'
], (
  ComponentStore
  rivets
) ->
  'use strict'

  ## Backbone.Marionette.Component.ItemView
  ## --------------------------------------

  ## Description
  ##
  ##

  class ItemView extends Backbone.Marionette.ItemView

    constructor: () ->
      @_componentStore = new ComponentStore
      super

    add: (components...) ->
      @_componentStore.add.apply @_componentStore, components

      for component in components
        component.setViewInstance @

    contains: (component) ->
      @_componentStore.contains component

    removeComponent: (component) ->
      @_componentStore.remove component

    ###
      Binding the model data to the view instance
    ###
    onRender: ->
      data = {}

      @_componentStore.each (component) ->
        component.onBeforeRender()

      @_componentStore.each (component) ->
        data = _.extend data, component.getModelData()

      @rivetsView = rivets.bind @$el, data

      @_componentStore.each (component) ->
        component.onAfterRender()

    ###
      Unbind rivetsView when component is closed
    ###
    onClose: () ->
      @_componentStore.each (component) ->
        component.onBeforeClose()

      @rivetsView.unbind() if @rivetsView

      @_componentStore.each (component) ->
        component.onAfterClose()

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.ItemView or= ItemView
