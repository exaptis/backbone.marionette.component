define [
  'lib/component/Component'
  'lib/component/form/Button'
], (
  Component
  Button
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.SubmitButton
  ## ------------------------------------------

  ## Description
  ##
  ##

  class SubmitButton extends Button

    constructor: (@componentId) ->
      super @componentId, (event) =>
        event.preventDefault()
        form = @getParent()
        form.process()

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.SubmitButton or= SubmitButton
