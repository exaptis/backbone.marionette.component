define [
  'modules/main/behavior/MaterializeBehavior'
  'hbs!templates/modules/main/views/WelcomeItemViewTemplate'
], (
  MaterializeBehavior
  WelcomeItemViewTemplate
) ->
  'use strict'

  class WelcomeItemView extends Backbone.Marionette.ItemView
    template: WelcomeItemViewTemplate

    materialize:
      behaviorClass: MaterializeBehavior

