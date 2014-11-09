define [], () ->
  'use strict'

  class Map

    constructor: () ->
      @_entries = {}

    put: (key, object) ->
      unless @has(key)
        @_entries[key] = object

    get: (key) ->
      @_entries[key]

    clear: () ->
      @_entries = {}

    size: () ->
      @keys().length

  #Underscore methods that we want to implement on the Map.
  mapMethods = ['values', 'keys', 'has', 'each', 'isEmpty']

  #Mix in each Underscore method as a proxy to the private entries object
  _.each mapMethods, (method) ->
    Map::[method] = ->
      args = [].slice.call arguments
      args.unshift @_entries
      _[method].apply(_, args)

  return Map
