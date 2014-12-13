define [
  'State',
  'modules/main/controllers/HomeController',
  './ApplicationState'
], (State, HomeController, ApplicationState)->
  new class HomeState extends State
    route: ''
    parent: ApplicationState
    statename: 'home'
    onActivate: ->
      controller = new HomeController(@module.app)
      controller.showWelcomePage()
    initialize: (module)->
      @module = module
