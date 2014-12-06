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
        setTitle ''

      showMarkupComponent: (component) ->
        controller = new MarkupController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()
        setTitle component + ' Component'

      showFormComponent: (component) ->
        controller = new FormController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()
        setTitle component + ' Component'

      showViewComponent: (component) ->
        controller = new ViewController(module.app)
        controller["show#{_.string.capitalize(component)}Component"]()
        setTitle component + ' Component'

      showValidator: (validator) ->
        controller = new ValidationController(module.app)
        controller["show#{_.string.capitalize(validator)}Validator"]()
        setTitle validator + ' Validator'

    setTitle = (component) ->
      title = 'Component.js'

      if component.length
        title +=  ' | ' + _.string.capitalize component

      document.title = title

    new MainAppRouter
      controller: API
