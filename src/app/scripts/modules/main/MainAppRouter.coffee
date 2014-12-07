define [
  'modules/main/controllers/MarkupController'
  'modules/main/controllers/FormController'
  'modules/main/controllers/ViewController'
  'modules/main/controllers/HomeController'
  'underscore.string'
], (
  MarkupController
  FormController
  ViewController
  HomeController
) ->
  'use strict'

  class MainAppRouter extends Backbone.Marionette.AppRouter

    appRoutes:
      '':'showPage'
      'component/markup/:component': 'showMarkupComponent'
      'component/form/:component': 'showFormComponent'
      'component/view/:component': 'showViewComponent'

  initialize: (module) ->
    API =
      showPage: ->
        controller = new HomeController(module.app)
        controller.showWelcomePage()
      showMarkupComponent: (component) ->
        controller = new MarkupController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

      showFormComponent: (component) ->
        controller = new FormController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

      showViewComponent: (component) ->
        controller = new ViewController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

    new MainAppRouter
      controller: API
