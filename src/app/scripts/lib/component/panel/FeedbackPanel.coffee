define [
  'lib/component/panel/BasePanel'
  'lib/component/validation/validator/BaseValidator'
], (
  BasePanel
  BaseValidator
) ->
  'use strict'

  class FeedbackPanel extends BasePanel

    constructor: (@componentId, @filter) ->
      super

    setFeedbackList: (collection) ->
#      if @filter
#        @_feedbackList = new FilteredCollection collection, filter: (validationError) =>
#          validationError.getComponentId() is @filter
#      else
      @_feedbackList = collection

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
      delete @_feedbackList
