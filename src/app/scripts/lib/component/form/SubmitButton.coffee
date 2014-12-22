define [
  'lib/component/Component'
], (
  Component
) ->
  'use strict'

  ## Backbone.Marionette.Component.Form.Button
  ## ------------------------------------------

  ## Description
  ##
  ##

  class SubmitButton extends Component

    constructor: (@componentId) ->
      super @componentId

    render: () ->
      tag = @getDomNode()
      @getDomNode().attr 'type', 'submit'
      @getDomNode().on 'click', (event) =>
        @callback.call(@viewInstance, event)

    close: () ->
      @getDomNode().off 'click'


  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.Button or= Button
