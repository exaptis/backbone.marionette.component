define [
  'lib/component/utils/ComponentStore'
  'lib/component/panel/BasePanel'
  'lib/component/adapter/rivets'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.ItemView
  ## --------------------------------------

  ## Description
  ##
  ##

  class ItemView extends Backbone.Marionette.ItemView

    constructor: () ->
      @_componentStore = new Backbone.Marionette.Component.ComponentStore
      @_feedbackList = new Backbone.Collection
      super

    getFeedbackList: -> @_feedbackList

    add: (components...) ->
      @_componentStore.add.apply @_componentStore, components

      for component in components
        component.setParent @
        component.setViewInstance @

        if component instanceof Backbone.Marionette.Component.BasePanel
          component.setFeedbackList @_feedbackList

    contains: (component) ->
      @_componentStore.contains component

    removeComponent: (component) ->
      @_componentStore.remove component

    ###
      Binding the model data to the view instance
    ###
    render: ->
      super

      data = {}

      @_componentStore.each (component) ->
        component.render()

      @_componentStore.each (component) ->
        data = _.extend data, component.getModelData()

      @rivetsView = rivets.bind @$el, data


    ###
      Unbind rivetsView when component is closed
    ###
    close: () ->
      @_componentStore.each (component) ->
        component.close()

      @rivetsView.unbind() if @rivetsView

    ###
      Destroy components
    ###
    destroy: () ->
      @_componentStore.each (component) ->
        component.destroy()

      super

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.ItemView or= ItemView
