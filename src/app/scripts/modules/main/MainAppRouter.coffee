define [
  'modules/main/controllers/markup/LabelMarkupController'
], (
  LabelMarkupController
) ->
  'use strict'

  class MainAppRouter extends Backbone.Marionette.AppRouter

    appRoutes:
      'component/markup/label': 'showLabelMarkupComponent'

  initialize: (module) ->
    API =
      showLabelMarkupComponent: () ->
        new LabelMarkupController(module.app)

    new MainAppRouter
      controller: API
