define [
  'lib/component/generics/Map'
], (Map) ->
  'use strict'

  describe 'Map', ->
    TEST_MAP = null
    TEST_ID_1 = 'id1'
    TEST_ID_2 = 'id2'
    TEST_OBJECT_1 = {foo: 'bar'}
    TEST_OBJECT_2 = {bar: 'foor'}

    beforeEach ->
      TEST_MAP = new Map

    it 'should be an instantce of Map', ->
      expect(TEST_MAP).to.be.an.instanceof Map
      expect(TEST_MAP.constructor.name).to.be.equal 'Map'

    it 'should be empty after initialization', ->
      expect(TEST_MAP.isEmpty()).to.be.true

    it 'should be empty after cleared', ->
      #given
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)

      #when
      TEST_MAP.clear()

      #then
      expect(TEST_MAP.size()).to.be.equal 0
      expect(TEST_MAP.isEmpty()).to.be.true

    it 'should put single item into the map', ->
      #when
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)

      #then
      expect(TEST_MAP.size()).to.be.equal 1

    it 'should put multiple items into the map', ->
      #when
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)

      #then
      expect(TEST_MAP.size()).to.be.equal 2

    it 'should not put duplicates into the map', ->
      #when
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_2)
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_2)

      #then
      expect(TEST_MAP.size()).to.be.equal 1

    it 'should get item by key', ->
      #WHEN
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)

      #then
      expect(TEST_MAP.get(TEST_ID_1)).to.be.equal TEST_OBJECT_1
      expect(TEST_MAP.get(TEST_ID_2)).to.be.equal TEST_OBJECT_2

    it 'should remove item by key', ->
      #WHEN
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)

      #then
      expect(TEST_MAP.get(TEST_ID_1)).to.be.equal TEST_OBJECT_1
      expect(TEST_MAP.get(TEST_ID_2)).to.be.equal TEST_OBJECT_2

    it 'should return the keys of the map', ->
      #given
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)

      #when
      mapKeys = TEST_MAP.keys()

      #then
      expect(mapKeys.length).to.be.equal 2
      expect(mapKeys).to.be.eql [TEST_ID_1, TEST_ID_2]


    it 'should return the values of the map', ->
      #given
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)

      #when
      mapValues = TEST_MAP.values()

      #then
      expect(mapValues.length).to.be.equal 2
      expect(mapValues).to.be.eql [TEST_OBJECT_1, TEST_OBJECT_2]

    it 'should verify the presence of an object', ->
      #when
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)

      #then
      expect(TEST_MAP.has(TEST_ID_1)).to.be.true
      expect(TEST_MAP.has(TEST_ID_2)).to.be.false

    it 'should iterate through the map', ->
      #given
      TEST_MAP.put(TEST_ID_1, TEST_OBJECT_1)
      TEST_MAP.put(TEST_ID_2, TEST_OBJECT_2)
      results = []

      #when
      TEST_MAP.each (item) ->
        results.push item

      #then
      expect(results).to.be.eql [TEST_OBJECT_1, TEST_OBJECT_2]



