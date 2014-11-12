define ['backbone.marionette'], (Marionette) ->
  'use strict'

  class Application extends Marionette.Application

    regions:
      linksRegion: '#links-region'
      contentRegion: '#content-region'
