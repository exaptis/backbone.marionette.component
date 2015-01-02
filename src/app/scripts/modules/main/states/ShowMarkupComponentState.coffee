define [
  './ShowState'
  'modules/main/controllers/MarkupController'
], (ShowState, MarkupController)->
  new class ShowMarkupComponent extends ShowState
    route: 'component/markup/:component'
    statename: 'showMarkupComponent'
    controller: MarkupController
