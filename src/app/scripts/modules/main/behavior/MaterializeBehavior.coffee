define ['material','ripples'], () ->
  'use strict'

  class MaterializeBehavior extends Marionette.Behavior

    onShow: ->
      $.material.init()
