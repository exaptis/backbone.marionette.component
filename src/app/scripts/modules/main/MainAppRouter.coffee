define [
  'modules/main/controllers/MarkupController'
  'modules/main/controllers/FormController'
], (
  MarkupController
  FormController
) ->
  'use strict'

  class MainAppRouter extends Backbone.Marionette.AppRouter

    appRoutes:
      'component/markup/label': 'showLabelMarkupComponent'
      'component/form/textField': 'showTextFieldFormComponent'

  initialize: (module) ->
    API =
      showLabelMarkupComponent: () ->
        controller = new MarkupController(module.app)
        controller.showLabelMarkupComponent()

      showTextFieldFormComponent: () ->
        controller = new FormController(module.app)
        controller.showTextFieldComponent()

    new MainAppRouter
      controller: API
