define [
  'lib/component/validation/validator/PatternValidator'
], (
  PatternValidator
) ->
  'use strict'

  class EmailAddressValidator extends PatternValidator

    NAME: 'EmailAddressValidator'

    constructor: () ->
      super '^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*((\.[A-Za-z]{2,}){1}$)', 'ig'
