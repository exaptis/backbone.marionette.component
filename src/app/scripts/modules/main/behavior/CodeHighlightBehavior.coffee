define ['prism'], (Prism) ->
  'use strict'

  class CodeHighlightBehavior extends Marionette.Behavior

    onShow: ->
      @$el.find('code').each (index, element) ->
        Prism.highlightElement element
