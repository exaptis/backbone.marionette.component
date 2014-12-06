define [
  'State'
  'modules/main/controllers/MarkupController'
  'ApplicationState'
  'underscore.string'
], (State, MarkupController, ApplicationState)->
  new class ShowMarkupComponent extends State
    route: 'component/markup/:component'
    parent: ApplicationState
    statename: 'showMarkupComponent'
    onActivate: (parameters)->
      controller = new MarkupController(@module.app)
      controller["show#{_.string.capitalize(parameters.component)}Component"]()
    initialize: (module)->
      @module = module
