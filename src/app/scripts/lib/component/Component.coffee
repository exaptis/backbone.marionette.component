define [
  'lib/component/utils/InstanceCounter'
  'lib/component/validation/ValidationError'
  'lib/component/validation/validator/BaseValidator'
], () ->
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
    compentInstanceCounter = new Backbone.Marionette.Component.InstanceCounter

    triggerMethod: Marionette.triggerMethod

    constructor: (@componentId) ->
      unless @componentId
        throw new Error "componentId needs to be specified"

      # Generate unique ID
      @cid = 'c' + compentInstanceCounter.incrementCounter()

      # Validator Store
      @_validators = []

      # Errors Store
      @_validationErrors = []

      @parentComponent = null

    # ComponentId
    setComponentId: (@componentId) ->

    getComponentId: () -> @componentId

    # Model
    setModel: (@model) ->

    getModel: () -> @model

    # Property
    setProperty: (@property) ->

    getProperty: () -> @property

    # View Instance
    setViewInstance: (@viewInstance) ->

    getViewInstance: () -> @viewInstance

    # Parent
    setParent: (@parent) ->

    getParent: () -> @parent

    # Component Value
    getValue: () -> @model.get @property

    getValidationErrors: () -> @_validationErrors

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
      Add validators to the component
    ###
    add: (components...) ->
      for component in components
        if component instanceof Backbone.Marionette.Component.BaseValidator
          @_validators.push component
        if component instanceof Backbone.Marionette.Component.ValidationError
          @_validationErrors.push component
    ###
      Called when the component is rendered
    ###
    render: ->

    ###
      Called when the component is closed
    ###
    close: ->

    ###
      Called when the component is validated
    ###
    validate: ->
      @_validationErrors = []

      for validator in @_validators
        validator.validate @

    ###
      Called when the component is destroyed
    ###
    destroy: ->
      delete @parent if @parent

    _.extend Component::, Backbone.Events

  Backbone.Marionette or= {}
  Backbone.Marionette.Component.Component or= Component
