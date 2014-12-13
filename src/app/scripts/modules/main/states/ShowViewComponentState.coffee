define [
  'State'
  'modules/main/controllers/ViewController'
  './ApplicationState'
  'underscore.string'
], (State, ViewController, ApplicationState)->
  new class ShowViewComponent extends State
    route: 'component/view/:component'
    parent: ApplicationState
    statename: 'showViewComponent'
    onActivate: (parameters)->
      controller = new ViewController(@module.app)
      controller["show#{_.string.capitalize(parameters.component)}Component"]()
    initialize: (module)->
      @module = module
