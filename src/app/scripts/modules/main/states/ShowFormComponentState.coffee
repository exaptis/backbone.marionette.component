define [
  'State'
  'modules/main/controllers/FormController'
  'ApplicationState'
  'underscore.string'
], (State, FormController, ApplicationState)->
  new class ShowFormComponent extends State
    route: 'component/form/:component'
    parent: ApplicationState
    statename: 'showFormComponent'
    onActivate: (parameters)->
      controller = new FormController(@module.app)
      controller["show#{_.string.capitalize(parameters.component)}Component"]()
    initialize: (module)->
      @module = module
