define [
  'State'
  'underscore.string'
], (State)->
  class ModuleState extends State
    initialize: (module)->
      @module = module
