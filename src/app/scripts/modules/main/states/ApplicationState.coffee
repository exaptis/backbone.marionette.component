define ['State', 'modules/main/controllers/HomeController'], (State, HomeController)->
  new class ApplicationState extends State
    abstract: true
    statename: 'bbmc'
    onActivate: ->
