require ['require-config'], ->
  'use strict'

  require.config
    baseUrl: '/scripts'
    deps: [
      'main'
      'bootstrap'
      'backbone.marionette'
    ]
