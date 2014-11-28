define [
  'lib/component/Component'
  'lib/component/form/DropDown'
], (
  Component
  DropDown
) ->
  'use strict'

  describe 'DropDown', ->
    COMPONENT_ID = "COMPONENT_ID"
    COMPONENT_PROPERTY = "COMPONENT_PROPERTY"

    TEXT_1 = 'TEXT_1'
    TEXT_2 = 'TEXT_2'

    VALUE_1 = 'VALUE_1'
    VALUE_2 = 'VALUE_2'

    ERROR_MESSAGE_MODEL = 'model needs to be specified'
    ERROR_MESSAGE_COLLECTION = 'collection needs to be specified'
    ERROR_MESSAGE_UNSUPPORTED_METHOD = 'Unsupported Method, use getDomNodes() instead.'

    before ->
      @viewInstance =
        $: jQuery
        $el: $('#fixture')

    beforeEach ->
      @model = new Backbone.Model(COMPONENT_PROPERTY: null)
      @collection = new Backbone.Collection [
        value: VALUE_1, text: TEXT_1
      , value: VALUE_2, text: TEXT_2
      ]

      @select = new DropDown COMPONENT_ID, COMPONENT_PROPERTY, @model, @collection

      @targetNode = $("<input>").attr
        'component-id': COMPONENT_ID
        'name': 'radioGroup'
        'type': 'radio'

      @viewInstance.$el.append @targetNode

    afterEach ->
      @viewInstance.$el.empty()

    it 'should be an instantce of DropDown', ->
      expect(@select).to.be.an.instanceof DropDown
      expect(@select).to.be.an.instanceof Component
      expect(@select.constructor.name).to.be.equal 'Dropdown'

    it 'should throw an error if no id and no model is passed', ->
      expect(-> new DropDown()).to.throw ERROR_MESSAGE_MODEL

    it 'should throw an error if no collection is passed', ->
      expect(=> new DropDown(COMPONENT_ID, COMPONENT_PROPERTY, @model)).to.throw ERROR_MESSAGE_COLLECTION;

    it 'should throw an error if getDomNode is called', ->
      expect(=> @select.getDomNode()).to.throw ERROR_MESSAGE_UNSUPPORTED_METHOD

    it 'should call beforeRender and getDomNodes when rendered', ->
      #given
      @select.setViewInstance(@viewInstance)

      sinon.spy @select, 'beforeRender'
      sinon.spy @select, 'getDomNodes'

      #when
      @select.render()

      #then
      @select.beforeRender.should.have.been.calledOnce
      @select.getDomNodes.should.have.been.calledOnce

    it 'should have no selected radio button', ->
      #given
      @select.setViewInstance(@viewInstance)

      #when
      @select.render()

      #then
      options = @select.getDomNodes().find('option')
      expect($(options.get(0)).prop('checked')).to.be.false
      expect($(options.get(1)).prop('checked')).to.be.false

    it 'should select radio button based on model value', ->
      #given
      @model.set COMPONENT_PROPERTY, VALUE_1
      @select.setViewInstance(@viewInstance)

      #when
      @select.render()

      #then
      options = @select.getDomNodes().find('option')
      expect($(options.get(0)).prop('checked')).to.be.true
      expect($(options.get(1)).prop('checked')).to.be.false

