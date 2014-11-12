define [], () ->
  'use strict'

  ## Backbone.Marionette.Util.InstanceCounter
  ## -----------------------------

  ##
  ## Instance counter for generating unique ids
  ##

  class InstanceCounter
    counter = 0

    getCounter: () ->
      counter

    incrementCounter: () ->
      ++counter
