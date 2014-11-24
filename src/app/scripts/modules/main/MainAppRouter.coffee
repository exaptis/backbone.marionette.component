define [
  'modules/main/controllers/MarkupController'
  'modules/main/controllers/FormController'
  'underscore.string'
], (
  MarkupController
  FormController
) ->
  'use strict'

  class MainAppRouter extends Backbone.Marionette.AppRouter

    appRoutes:
      'component/markup/:component': 'showMarkupComponent'
      'component/form/:component': 'showFormComponent'

  initialize: (module) ->
    API =
      showMarkupComponent: (component) ->
        controller = new MarkupController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

      showFormComponent: (component) ->
        controller = new FormController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

    new MainAppRouter
      controller: API
