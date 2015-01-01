define [
  'modules/main/views/EmailAddressValidatorView'
  'modules/main/views/StringValidatorView'
  'modules/main/views/PatternValidatorView'
], (
  EmailAddressValidatorView
  StringValidatorView
  PatternValidatorView
) ->
  'use strict'

  class ValidationController extends Backbone.Marionette.Controller

    initialize: (@app) ->

    showEmailAddressValidator: ->
      @app.contentRegion.show new EmailAddressValidatorView

    showStringValidator: ->
      @app.contentRegion.show new StringValidatorView

    showPatternValidator: ->
      @app.contentRegion.show new PatternValidatorView


