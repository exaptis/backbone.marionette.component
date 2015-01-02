define [
  'lib/component/state/ModuleState',
  'modules/main/controllers/HomeController',
  './ApplicationState'
], (ModuleState, HomeController, ApplicationState)->
  new class HomeState extends ModuleState
    route: ''
    parent: ApplicationState
    statename: 'home'
    onActivate: ->
      controller = new HomeController(@module.app)
      controller.showWelcomePage()
