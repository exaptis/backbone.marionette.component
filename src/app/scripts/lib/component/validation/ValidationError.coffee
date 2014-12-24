define [], () ->
  'use strict'

  class ValidationError extends Backbone.Model

    defaults:
      errorMessage: ''

    initialize: (attributes, options) ->
      { @validatorName, @componentId } = options

      @on 'change', =>
        @set 'errorMessage', @getErrorMessage()

      @trigger 'change'

    getErrorMessage: () ->
      errorKey = []
      errorKey.push @validatorName
      errorKey.push @componentId

      for key, value of @attributes
        unless key is 'errorMessage'
          errorKey.push key

      errorKey.join '.'
