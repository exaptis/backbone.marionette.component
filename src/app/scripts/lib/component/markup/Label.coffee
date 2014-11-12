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

    render: () ->
      if @model
        @getDomNode().attr('rv-text', "#{@cid}:#{@value}")
        super
      else
        @getDomNode().text(@value)


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Label or= Label
