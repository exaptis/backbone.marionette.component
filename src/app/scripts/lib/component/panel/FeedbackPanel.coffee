define [
  'lib/component/panel/BasePanel'
  'lib/component/utils/FilteredCollection'
], () ->
  'use strict'

  class FeedbackPanel extends Backbone.Marionette.Component.BasePanel

    constructor: (@componentId, @filter) ->
      super

    setFeedbackList: (collection) ->
      if @filter
        @_feedbackList = new Backbone.Marionette.Component.FilteredCollection collection, filter: @componentFilter
      else
        @_feedbackList = collection

    componentFilter: (validationError) =>
      validationError.getComponentId() is @filter.getComponentId()

    render: ->
      ITEM_NAME = 'feedback'

      repeatingElement = $('<li>')
      repeatingElement.attr "rv-each-#{ITEM_NAME}", "collection#{@cid}:models"
      repeatingElement.attr "rv-text", "#{ITEM_NAME}:errorMessage"

      listNode = $('<ul>')
      listNode.append repeatingElement

      panelNode = @getDomNode()
      panelNode.attr 'rv-show', "collection#{@cid}:length"
      panelNode.append listNode

    getModelData: () ->
      data = {}
      data["collection#{@cid}"] = @_feedbackList
      data

    destroy: ->
      delete @filter
      delete @_feedbackList

  Backbone.Marionette.Component or= {}
  Backbone.Marionette.Component.FeedbackPanel or= FeedbackPanel

