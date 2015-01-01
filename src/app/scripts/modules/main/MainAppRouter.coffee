define [
  'modules/main/controllers/MarkupController'
  'modules/main/controllers/FormController'
  'modules/main/controllers/ViewController'
  'modules/main/controllers/ValidationController'
  'modules/main/controllers/HomeController'
  'underscore.string'
], (
  MarkupController
  FormController
  ViewController
  ValidationController
  HomeController
) ->

  class MainAppRouter extends Backbone.Marionette.AppRouter
    appRoutes:
      '':'showWelcomePage'
      'markup/:component': 'showMarkupComponent'
      'form/:component': 'showFormComponent'
      'view/:component': 'showViewComponent'
      'validation/:validator': 'showValidator'
  initialize: (module) ->
    API =
      showWelcomePage: ->
        controller = new HomeController(module.app)
        controller.showWelcomePage()

      showMarkupComponent: (component) ->

      showFormComponent: (component) ->
        controller = new FormController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

      showViewComponent: (component) ->
        controller = new ViewController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()

      showValidator: (validator) ->
        controller = new ValidationController(module.app)
        controller["show#{_.string.capitalize(validator)}Validator"]()

    new MainAppRouter
      controller: API
