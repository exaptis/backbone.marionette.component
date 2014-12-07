define [
  'hbs!/templates/modules/main/views/WelcomeItemViewTemplate'
], (
  WelcomeItemViewTemplate
) ->
  'use strict'

  class WelcomeItemView extends Backbone.Marionette.ItemView
    template: WelcomeItemViewTemplate

