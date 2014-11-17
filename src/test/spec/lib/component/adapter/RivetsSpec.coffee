define [
  'lib/component/adapter/rivets'
], (Component) ->
  'use strict'

  describe 'Rivets', ->
    KEY_PATH = 'KEY_PATH'
    VALUE = 'VALUE'
    EXCEPTION_MESSAGE = 'object not supported for rv-adapter ":"'

    beforeEach ->
      @adapter = rivets.adapters[":"]
      @model = new Backbone.Model KEY_PATH: VALUE
      @collection = new Backbone.Collection [@model]
      @callbackSpy = sinon.spy()

    describe 'Observe', ->
      it 'should observe changes on a backbone.model', ->
        #given
        onSpy = sinon.spy @model, 'on'

        #when
        @adapter.observe @model, KEY_PATH, @callbackSpy

        #then
        onSpy.should.have.been.called
        onSpy.should.have.been.calledOnce
        onSpy.should.have.been.calledWith "change:#{KEY_PATH}", @callbackSpy

      it 'should observe changes on a backbone.collection', ->
        #given
        onSpy = sinon.spy @collection, 'on'

        #when
        @adapter.observe @collection, KEY_PATH, @callbackSpy

        #then
        onSpy.should.have.been.called
        onSpy.should.have.been.callCount 4
        onSpy.should.have.been.calledWith "add remove reset", @callbackSpy
        onSpy.should.have.been.calledWith "add", @callbackSpy
        onSpy.should.have.been.calledWith "remove", @callbackSpy
        onSpy.should.have.been.calledWith "reset", @callbackSpy

      it 'should throw an error for unsupported object', ->
        #given
        spy = sinon.spy()

        #when
        observeSpy = =>
          @adapter.observe spy, KEY_PATH, @callbackSpy

        #then
        expect(observeSpy).to.throw EXCEPTION_MESSAGE

    describe 'Unobserve', ->
      it 'should unobserve changes on a backbone.model', ->
        #given
        offSpy = sinon.spy @model, 'off'

        #when
        @adapter.unobserve @model, KEY_PATH, @callbackSpy

        #then
        offSpy.should.have.been.called
        offSpy.should.have.been.calledOnce
        offSpy.should.have.been.calledWith "change:#{KEY_PATH}", @callbackSpy

      it 'should unobserve changes on a backbone.collection', ->
        #given
        offSpy = sinon.spy @collection, 'off'

        #when
        @adapter.unobserve @collection, KEY_PATH, @callbackSpy

        #then
        offSpy.should.have.been.called
        offSpy.should.have.been.calledOnce
        offSpy.should.have.been.calledWith "add remove reset", @callbackSpy

      it 'should throw an error for unsupported object', ->
        #given
        spy = sinon.spy()

        #when
        unobserveSpy = =>
          @adapter.unobserve spy, KEY_PATH, @callbackSpy

        #then
        expect(unobserveSpy).to.throw EXCEPTION_MESSAGE

    describe 'Get', ->
      it 'should get value by key path from a backbone.model', ->
        #given
        getSpy = sinon.spy @model, 'get'

        #when
        modelValue = @adapter.get @model, KEY_PATH

        #then
        expect(modelValue).to.be.equal VALUE
        getSpy.should.have.been.called
        getSpy.should.have.been.calledOnce
        getSpy.should.have.been.calledWith KEY_PATH

      it 'should get attribute by key path from a backbone.collection', ->
        #when
        collectionAttribute = @adapter.get @collection, 'length'

        #then
        expect(collectionAttribute).to.be.equal 1

      it 'should throw an error for unsupported object', ->
        #given
        spy = sinon.spy()

        #when
        observeSpy = =>
          @adapter.get spy, KEY_PATH

        #then
        expect(observeSpy).to.throw EXCEPTION_MESSAGE

    describe 'Set', ->
      it 'should get value by key path from a backbone.model', ->
        #given
        setSpy = sinon.spy @model, 'set'

        #when
        modelValue = @adapter.set @model, KEY_PATH, VALUE

        #then
        setSpy.should.have.been.called
        setSpy.should.have.been.calledOnce
        setSpy.should.have.been.calledWith KEY_PATH, VALUE

      it 'should set attribute by key path from a backbone.collection', ->
        #when
        @adapter.set @collection, KEY_PATH, VALUE

        #then
        expect(@collection[KEY_PATH]).to.be.equal VALUE

      it 'should throw an error for unsupported object', ->
        #given
        spy = sinon.spy()

        #when
        observeSpy = =>
          @adapter.set spy, KEY_PATH, VALUE

        #then
        expect(observeSpy).to.throw EXCEPTION_MESSAGE


