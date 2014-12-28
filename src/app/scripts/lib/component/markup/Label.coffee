define [
  'lib/component/Component'
], () ->
  'use strict'

  ## Backbone.Marionette.Component.Markup.Label
  ## ------------------------------------------

  ## Description
  ##
  ##

  class Label extends Backbone.Marionette.Component.Component

    constructor: (@componentId, @value, @model) ->
      super @componentId, @model

    render: () ->
      if @model
        @getDomNode().attr('rv-text', "#{@cid}:#{@value}")
      else
        @getDomNode().text(@value)

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Label or= Label
