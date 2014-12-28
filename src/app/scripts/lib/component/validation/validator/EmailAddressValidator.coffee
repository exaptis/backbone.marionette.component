define [
  'lib/component/validation/validator/PatternValidator'
], () ->
  'use strict'

  class EmailAddressValidator extends Backbone.Marionette.Component.PatternValidator

    NAME: 'EmailAddressValidator'

    constructor: () ->
      super '^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*((\.[A-Za-z]{2,}){1}$)', 'ig'

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.EmailAddressValidator or= EmailAddressValidator
