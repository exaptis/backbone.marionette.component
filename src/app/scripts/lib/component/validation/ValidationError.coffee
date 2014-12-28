define [
  'i18n'
  'underscore.string'
], (
  i18n
) ->
  'use strict'

  class ValidationError extends Backbone.Model

    defaults:
      errorMessage: ''

    initialize: (attributes, options) ->
      { @validatorName, @validationName, @componentId } = options

      @on 'change', @updateErrorMessage

      do @updateErrorMessage

    updateErrorMessage: ->
      @set 'errorMessage', i18n.t @getErrorKey(), @getErrorValues(), silent: true

    getComponentId: () -> @componentId

    getErrorKey: () ->
      errorKey = []
      errorKey.push @componentId
      errorKey.push @validatorName
      errorKey.push @validationName

      errorKey = _.map errorKey, (name) -> _.string.capitalize name
      errorKey.join '.'

    getErrorValues: () ->
      _.omit @toJSON(), 'errorMessage'

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.ValidationError or= ValidationError
