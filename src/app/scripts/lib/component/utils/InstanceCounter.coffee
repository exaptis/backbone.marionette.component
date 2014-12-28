define [], () ->
  'use strict'

  ## Backbone.Marionette.Util.InstanceCounter
  ## -----------------------------

  ##
  ## Instance counter for generating unique ids
  ##

  class InstanceCounter
    constructor: ->
      counter = 0

      @getCounter = ->
        counter

      @incrementCounter = ->
        ++counter

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.InstanceCounter or= InstanceCounter
