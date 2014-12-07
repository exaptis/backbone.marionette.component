define [
  'modules/main/views/ItemView'
  'modules/main/views/CollectionItemView'
  'modules/main/views/CompositeItemView'
], (
  ItemView
  CollectionItemView
  CompositeItemView
) ->
  'use strict'

  class ViewController extends Backbone.Marionette.Controller

    initialize: (@app) ->
      @collection = new Backbone.Collection [
        id: 1, name: 'David'
      ,
        id: 2, name: 'Thomas'
      ,
        id: 3, name: 'Markus'
      ]

    showItemViewComponent: ->
      @app.contentRegion.show new ItemView(model: model = @collection.at(1))

    showCollectionViewComponent: ->
      @app.contentRegion.show new CollectionItemView(collection: @collection)

    showCompositeViewComponent: ->
      @app.contentRegion.show new CompositeItemView(collection: @collection)


