define [
  'lib/component/utils/InstanceCounter'
], (InstanceCounter) ->
  'use strict'

  describe 'InstanceCounter', ->
    beforeEach ->
      @instanceCounter = new InstanceCounter

    it 'should return the current counter', ->
      expect(@instanceCounter.getCounter()).to.be.equal 0

    it 'should increment the counter', ->
      expect(@instanceCounter.incrementCounter()).to.be.equal 1

    it 'should increment and return the current counter', ->
      #given
      expect(@instanceCounter.getCounter()).to.be.equal 0

      #when
      @instanceCounter.incrementCounter()

      #then
      expect(@instanceCounter.getCounter()).to.be.equal 1

