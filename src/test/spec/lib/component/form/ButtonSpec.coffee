define [
  'lib/component/Component'
  'lib/component/form/Button'
  'mocks/component/MockedItemView'
], (
  Component
  Button
  MockedItemView
) ->
  'use strict'

  describe 'Button', ->
    COMPONENT_ID = "COMPONENT_ID"

    beforeEach ->
      @callbackSpy = sinon.spy()
      @button = new Button COMPONENT_ID, @callbackSpy
      @targetNode = $("<button>").attr 'component-id', COMPONENT_ID

      @view = new MockedItemView
      @view.$el.append @targetNode
      @view.add @button

      sinon.spy jQuery.fn, 'on'
      sinon.spy jQuery.fn, 'off'

    afterEach ->
      @view.$el.empty()

      jQuery.fn.on.restore()
      jQuery.fn.off.restore()

    it 'should be an instance of Button', ->
      expect(@button).to.be.an.instanceof Button
      expect(@button).to.be.an.instanceof Component
      expect(@button.constructor.name).to.be.equal 'Button'

    it 'should throw an error if no callback is passed', ->
      expect(-> new Button()).to.throw(Error);

    it 'should register click callback on before render', ->
      #when
      @button.onBeforeRender()

      #then
      jQuery.fn.on.should.have.been.calledOnce

    it 'should unregister click callback on before close', ->
      #when
      @button.onBeforeClose()

      #then
      jQuery.fn.off.should.have.been.calledOnce

    it 'should execute callback on click', ->
      #given
      @view.render()

      #when
      @button.getDomNode().trigger 'click'

      #then
      @callbackSpy.should.have.been.calledOnce


