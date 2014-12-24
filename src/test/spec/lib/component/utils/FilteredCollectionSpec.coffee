define [
  'lib/component/utils/FilteredCollection'
], (FilteredCollection) ->
  'use strict'

  describe 'FilteredCollection', ->
    it 'should be an instance of Backbone.Collection', ->
      baseCollection = new Backbone.Collection

      collection = new FilteredCollection baseCollection, filter: (model) ->
        return true

      collection.should.be.an.instanceof Backbone.Collection
