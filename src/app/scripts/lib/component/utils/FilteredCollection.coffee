define [], () ->
  'use strict'

  class FilteredCollection extends Backbone.Collection

    constructor: (underlying, options = {}) ->

      @underlying = underlying
      @model = underlying.model
      @comparator = options.comparator or inducedOrdering(underlying)
      @options = _.extend {}, underlying.options, options

      super(@underlying.models.filter(@options.filter), options)

      @listenTo @underlying,

        reset: =>
          @reset(@underlying.models.filter(@options.filter))

        remove: (model) =>
          @remove(model) if @contains(model)

        add: (model) =>
          @add(model) if @options.filter(model)

        change: (model) =>
          @decideOn(model)

        sort: =>
          @sort() if @comparator.induced

    update: ->
      @decideOn(model) for model in @underlying.models

    decideOn: (model) ->
      if @contains(model)
        @remove(model) unless @options.filter(model)
      else
        @add(model) if @options.filter(model)

    inducedOrdering = (collection) ->
      func = (model) ->
        collection.indexOf(model)
      func.induced = true
      func
