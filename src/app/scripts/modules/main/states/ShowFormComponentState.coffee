define [
  './ShowState'
  'modules/main/controllers/FormController'
], (ShowState, FormController)->
  new class ShowFormComponent extends ShowState
    route: 'component/form/:component'
    statename: 'showFormComponent'
    controller: FormController
