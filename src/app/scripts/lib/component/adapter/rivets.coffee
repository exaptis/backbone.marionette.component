define ['rivets'], (rivets) ->
  'use strict'

  ###
  Backbone Adapter

  @type {{
    observer: observer,
    unobserve: unobserve,
    get: get,
    set: set
  }}
  ###

  rivets.adapters[":"] =
    observe: (obj, keypath, callback) ->
      if obj instanceof Backbone.Model
        obj.on 'change:' + keypath, callback
      else if obj instanceof Backbone.Collection
        obj.on 'add remove reset', callback
      else
        throw new Error 'object not supported for rv-adapter ":"'
      return

    unobserve: (obj, keypath, callback) ->
      if obj instanceof Backbone.Model
        obj.off 'change:' + keypath, callback
      else if obj instanceof Backbone.Collection
        obj.off 'add remove reset', callback
      else
        throw new Error 'object not supported for rv-adapter ":"'
      return

    get: (obj, keypath) ->
      if obj instanceof Backbone.Model
        return obj.get keypath
      else if obj instanceof Backbone.Collection
        return obj[keypath]
      else
        throw new Error 'object not supported for rv-adapter'
      return

    set: (obj, keypath, value) ->
      if obj instanceof Backbone.Model
        obj.set keypath, value
      else if obj instanceof Backbone.Collection
        obj[keypath] = value
      else
        throw new Error 'object not supported for rv-adapter'
      return

  rivets
