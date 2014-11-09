define [
  'lib/component/component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Markup.Label
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Label extends Component

    constructor: (@componentId, @value, @model) ->
      super


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Label or= Label
