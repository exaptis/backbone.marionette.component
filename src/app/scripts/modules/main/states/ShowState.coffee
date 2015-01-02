define [
  'lib/component/state/ModuleState'
  './ApplicationState'
  'underscore.string'
], (ModuleState, ApplicationState)->
  class ShowMarkupComponent extends ModuleState
    route: 'component/markup/:component'
    parent: ApplicationState
    statename: 'showMarkupComponent'
    onActivate: (parameters)->
      controller = new @controller(@module.app)
      controller["show#{_.string.capitalize(parameters.component)}Component"]()
    initialize: (module)->
      @module = module
