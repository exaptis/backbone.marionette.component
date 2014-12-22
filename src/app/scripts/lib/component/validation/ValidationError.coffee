define [], () ->
  'use strict'

  class ValidationError extends Backbone.Model

    initialize: (attributes, options = {}) ->
      { @validatorName, @componentId } = options

    getErrorMessage: () ->

      errorKey = []
      errorKey.push @validatorName
      errorKey.push @componentId

      for key, value of @attributes
        errorKey.push key

      errorKey.join '.'
