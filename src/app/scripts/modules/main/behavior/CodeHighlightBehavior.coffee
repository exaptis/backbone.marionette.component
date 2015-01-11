define [
  'prismjs'
  'prismjsCoffeescript'
], (PrismJs) ->
  'use strict'

  class CodeHighlightBehavior extends Marionette.Behavior

    onShow: ->
      @$el.find('code').each (index, element) ->
        PrismJs.highlightElement element
