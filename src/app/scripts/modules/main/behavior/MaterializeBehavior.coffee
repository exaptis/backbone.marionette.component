define [
  'material'
  'ripples'
  'selectize'
], () ->
  'use strict'

  class MaterializeBehavior extends Marionette.Behavior

    onShow: ->
      $.material.init()
      @view.$('select').selectize()

