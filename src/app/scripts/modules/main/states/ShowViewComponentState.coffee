define [
  './ShowState'
  'modules/main/controllers/ViewController'
], (ShowState, ViewController)->
  new class ShowViewComponent extends ShowState
    route: 'component/view/:component'
    statename: 'showViewComponent'
    controller: ViewController
