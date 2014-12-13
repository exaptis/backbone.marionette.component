define [
  'lib/component/Form'
  'lib/component/Component'
  'mocks/component/utils/MockedComponentStore'
], (
  Form
  Component
  MockedComponentStore
) ->
  'use strict'

  describe 'Form', ->
    COMPONENT_ID = 'COMPONENT_ID'
    MODEL_DATA = {foo: 'bar'}

    beforeEach ->
      @form = new Form COMPONENT_ID
      @store = @form._componentStore = new MockedComponentStore

      @component = new Component("componentId")
      @component.model = new Backbone.Model()


    it 'should be an instance of Component', ->
      expect(@form).to.be.an.instanceof Component
      expect(@form.constructor.name).to.be.equal 'Form'

    it 'should add one component to the view', ->
      #when
      @form.add(@component)

      #then
      expect(@form.contains(@component)).to.be.true
      @store.add.should.have.been.calledOnce

    it 'should remove component', ->
      #given
      @form.add @component

      #when
      @form.remove @component

      #then
      expect(@form.contains(@component)).to.be.false
      @store.remove.should.have.been.calledOnce

    it 'should add multiple components to the view', ->
      #given
      component1 = new Component("componentId1")
      component2 = new Component("componentId2")

      #when
      @form.add(component1, component2)

      #then
      expect(@form.contains(component1)).to.be.true
      expect(@form.contains(component2)).to.be.true
      @store.add.should.have.been.calledOnce

    it 'should call getModelData on every component', ->
      #given
      @form.add @component

      #when
      data = @form.getModelData()

      #then
      expect(data).to.be.eql @component.getModelData()

    it 'should call {methods} on every component', ->
      #given
      methods = [
        'onBeforeAdded'
        'onAfterAdded'
        'onBeforeRender'
        'onAfterRender'
        'onBeforeClose'
        'onAfterClose'
        'setViewInstance'
      ]

      @form.add @component

      for method in methods
        sinon.spy @component, method

      #when
      for method in methods
        @form[method]()

      #then
      for method in methods
        expect(@component[method]).to.be.calledOnce
#
