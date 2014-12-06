define [
  'lib/component/Component'
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
      super @componentId, @model

    onBeforeRender: () ->
      if @model
        @getDomNode().attr('rv-text', "#{@cid}:#{@value}")
      else
        @getDomNode().text(@value)


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Label or= Label
