define [
  'lib/component/utils/FilteredCollection'
], (FilteredCollection) ->
  'use strict'

  describe 'FilteredCollection', ->
    assertBaseCollection = (collection) ->
      collection.length.should.be.equal 4
      collection.at(0).get('a').should.be.equal 1
      collection.at(1).get('a').should.be.equal 2
      collection.at(2).get('a').should.be.equal 3
      collection.at(3).get('a').should.be.equal 4

    filter = (model) ->
      model.get('a') < 4 and model.get('a') > 1

    comparator = (model) ->
      model.get('b')

    beforeEach ->
      @baseItems = [
        a: 1, b: 2
      ,
        a: 2, b: 3
      ,
        a: 3, b: 1
      ,
        a: 4, b: 4
      ]

      @baseCollection = new Backbone.Collection @baseItems

    it 'should be an instance of Backbone.Collection', ->
      baseCollection = new Backbone.Collection

      collection = new Backbone.Marionette.Component.FilteredCollection baseCollection,
        filter: filter

      collection.should.be.an.instanceof Backbone.Collection

    it 'filters a collection', ->
      #given
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection @baseCollection,
        filter: filter

      #then
      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3
      assertBaseCollection @baseCollection

    it 'filters on reset', ->
      #given
      @baseCollection = new Backbone.Collection []
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection @baseCollection,
        filter: filter

      #when
      @baseCollection.reset(@baseItems)

      #then
      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3

      assertBaseCollection @baseCollection

    it 'responds to an remove event', ->
      #given
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection @baseCollection,
        filter: filter

      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3

      #when
      @baseCollection.remove @baseCollection.at(2)

      #then
      filteredCollection.length.should.be.equal 1
      filteredCollection.at(0).get('a').should.be.equal 2

      #when
      @baseCollection.remove @baseCollection.at(0)

      #then
      filteredCollection.length.should.be.equal 1
      filteredCollection.at(0).get('a').should.be.equal 2

    it 'responds to an add event', ->
      #given
      emptyCollection = new Backbone.Collection []
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection emptyCollection,
        filter: filter

      #when
      emptyCollection.add {a: 1}

      #then
      emptyCollection.length.should.be.equal 1
      filteredCollection.length.should.be.equal 0

      #when
      emptyCollection.add [{a: 2}, {a: 3}]

      #then
      emptyCollection.length.should.be.equal 3
      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3

      #when
      emptyCollection.add {a: 4}, at: 1

      #then
      emptyCollection.length.should.be.equal 4

      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3

    it 'responds to an @baseCollection change event', ->

      #given
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection @baseCollection,
        filter: filter

      #when
      @baseCollection.at(0).set('a', 1.5)

      #then
      filteredCollection.length.should.be.equal 3
      filteredCollection.at(0).get('a').should.be.equal 1.5
      filteredCollection.at(1).get('a').should.be.equal 2
      filteredCollection.at(2).get('a').should.be.equal 3

      #when
      @baseCollection.at(1).set('a', 5)

      #then
      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 1.5
      filteredCollection.at(1).get('a').should.be.equal 3

    it 'responds to a sort event if no comparator is provided', ->
      #given
      emptyCollection = new Backbone.Collection [],
        comparator: comparator

      emptyCollection.add @baseItems, sort: false

      #when
      filteredCollection = new Backbone.Marionette.Component.FilteredCollection emptyCollection,
        filter: filter

      #then
      filteredCollection.length.should.be.equal 2
      filteredCollection.at(0).get('a').should.be.equal 2
      filteredCollection.at(1).get('a').should.be.equal 3

      #when
      emptyCollection.sort()

      #then
      filteredCollection.at(0).get('a').should.be.equal 3
      filteredCollection.at(1).get('a').should.be.equal 2

  describe 'implementation of an efficient difference between two collections', ->

    class EfficientDifference extends Backbone.Marionette.Component.FilteredCollection
      constructor: (underlying, subtrahend, options = {}) ->

        options.filter =
          (model) -> not subtrahend.contains(model)

        super underlying, options

        @listenTo subtrahend,

          add: (model) =>
            @remove(model) if @contains(model)

          remove: (model) =>
            @add(model) if @underlying.contains(model)

          reset: @update.bind @

    a = new Backbone.Model()
    b = new Backbone.Model()
    c = new Backbone.Model()
    d = new Backbone.Model()

    baseCollection = new Backbone.Collection [a, b, c]
    subtrahendCollection = new Backbone.Collection [b, c, d]

    diffCollection = new EfficientDifference(baseCollection, subtrahendCollection)

    it 'contains models from minuend', ->
      diffCollection.length.should.be.equal 1
      diffCollection.contains(a).should.be.true

    it 'does not contain models from subtrahendCollection', ->
      diffCollection.contains(b).should.be.false
      diffCollection.contains(c).should.be.false

    it 'updates on changes in subtrahendCollection', ->
      #when
      subtrahendCollection.remove(b)

      #then
      diffCollection.length.should.be.equal 2
      diffCollection.contains(b).should.be.true

      #when
      subtrahendCollection.add(a)

      #then
      diffCollection.length.should.be.equal 1
      diffCollection.contains(a).should.be.false

      #when
      subtrahendCollection.reset([d])

      #then
      diffCollection.length.should.be.equal 3
      diffCollection.contains(a).should.be.true
      diffCollection.contains(b).should.be.true
      diffCollection.contains(c).should.be.true

