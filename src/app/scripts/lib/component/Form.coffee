define [
  'lib/component/Component'
  'lib/component/utils/ComponentStore'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.Form
  ## ----------------------------------

  ## Description
  ##
  ##

  class Form extends Backbone.Marionette.Component.Component

    constructor: (@componentId, options = {}) ->
      super
      { @onSubmit, @onError } = options
      @_componentStore = new Backbone.Marionette.Component.ComponentStore

    setViewInstance: (viewInstance) ->
      super

      @_componentStore.each (component) ->
        component.setViewInstance viewInstance

    getModelData: ->
      data = {}

      @_componentStore.each (component) ->
        data = _.extend data, component.getModelData()

      return data

    add: (components...) ->
      @_componentStore.add.apply @_componentStore, components
      for component in components then component.setParent @

    contains: (component) ->
      @_componentStore.contains.call @_componentStore, component

    remove: (component) ->
      @_componentStore.remove.call @_componentStore, component

    render: ->
      @_componentStore.each (component) ->
        component.render()

      form = @getDomNode()
      form.on 'submit', @process

    close: ->
      @_componentStore.each (component) ->
        component.close()

      form = @getDomNode()
      form.off 'submit'

    destroy: ->
      @_componentStore.each (component) ->
        component.destroy()

    ###
      Validate all nested components
    ###
    process: ->
      feedbackList = @getParent().getFeedbackList()
      feedbackList.reset()

      @_componentStore.each (component) ->
        component.validate()
        feedbackList.add component.getValidationErrors()

      if feedbackList.length
        @triggerMethod 'error', feedbackList
      else
        @triggerMethod 'submit'

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Form or= Form
