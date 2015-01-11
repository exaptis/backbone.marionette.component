"use strict"

module.exports = (grunt) ->

  # load all grunt tasks
  require('matchdep').filterDev("grunt-*").forEach grunt.loadNpmTasks

  # show elapsed time at the end
  require('time-grunt') grunt

  # configurable paths
  directoryConfig =
    root: ""
    srcApp: "src/app"
    srcTest: "src/test"
    srcServer: "src/server"
    build: "build"
    buildApp: "build/app"
    buildTest: "build/test"
    buildServer: "build/server"
    dist: "build/dist"
    bowerComponents: "../../../bower_components"

  grunt.initConfig
    dirs: directoryConfig
    ports:
      dev: "9001"
      test: "9002"
      dist: "9003"

  # cleaning up before starting - always called!
    clean:
      dev: [
        "<%= dirs.buildApp %>/*"
        "<%= dirs.buildApp %>/.[!.]*"
        "<%= dirs.buildTest %>/*"
        "<%= dirs.buildTest %>/.[!.]*"
      ]
      server: [
        "<%= dirs.buildServer %>/*"
        "<%= dirs.buildServer %>/.[!.]*"
      ]
      dist: [
        "<%= dirs.dist %>/*"
        "<%= dirs.dist %>/.[!.]*"
      ]


  # watch list
    watch:
      options:
        livereload: true

      index:
        files: [
          "<%= dirs.srcApp %>/*.html"
          "<%= dirs.srcTest %>/*.html"
        ]
        tasks: [
          "newer:copy:dev"
          "newer:copy:test"
          "preprocess:dev"
        ]

      static:
        files: [
          "<%= dirs.srcApp %>/locales/{,**/}*.json"
          "<%= dirs.srcApp %>/templates/{,**/}*.hbs"
          "<%= dirs.srcApp %>/images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        tasks: ["newer:copy:dev"]

      coffeeApp:
        files: ["<%= dirs.srcApp %>/scripts/{,**/}*.coffee"]
        tasks: ["newer:coffee:dev"]

      coffeeTest:
        files: ["<%= dirs.srcTest %>/{,**/}*.coffee"]
        tasks: ["newer:coffee:test"]

      less:
        files: [
          "<%= dirs.srcApp %>/styles/{,**/}*.less"
        ]
        tasks: [
          "newer:copy:dev"
          "less:dev"
          "autoprefixer:dev"
        ]
        options:
          livereload: false

      bower:
        files: [
          "<%= dirs.buildApp %>/scripts/init.js"
          "<%= dirs.buildTest %>/SpecRunner.js"
        ]
        tasks: [
          "bowerRequirejs"
        ]

      styles:
        files: ["<%= dirs.buildApp %>/styles/{,**/}*.css"]

      test:
        files: ["<%= dirs.buildTest %>/{,**/}*.js"]
        tasks: ["mocha:test"]
        options:
          livereload: false

  # copying all kind of files - no processing
    copy:
      dev:
        files: [
          expand: true
          dot: true
          cwd: "<%= dirs.srcApp %>"
          dest: "<%= dirs.buildApp %>"
          src: [
            "*.html"
            "templates/**"
            "locales/**"
            "*.{ico,txt}"
            ".htaccess"
            "styles/**"
            "images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
          ]
        ,
          expand: true
          dot: true
          cwd: "bower_components/bootstrap-material-design/fonts"
          dest: "<%= dirs.buildApp %>/fonts"
          src: ["**"]
        ]

      test:
        files: [
          expand: true
          dot: true
          cwd: "<%= dirs.srcTest %>"
          dest: "<%= dirs.buildTest %>"
          src: ["index.html"]
        ]

      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= dirs.srcApp %>"
          dest: "<%= dirs.dist %>"
          src: [
            "*.{ico,txt}"
            "scripts/appConf.js"
            ".htaccess"
            "locales/**"
            "styles/**"
            "images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
          ]
        ,
          expand: true
          dot: true
          cwd: "bower_components/almond"
          dest: "<%= dirs.dist %>/scripts"
          src: ['almond.js']
        ,
          expand: true
          dot: true
          cwd: "bower_components/bootstrap-material-design/fonts"
          dest: "<%= dirs.dist %>/fonts"
          src: ['**']
        ,
          expand: true
          dot: true
          cwd: "bower_components/prismjs"
          dest: "<%= dirs.dist %>/styles"
          src: ['prism-coy.css']
        ]

    coffee:
      options:
        bare: true
        sourceMap: true

      dev:
        files: [
          expand: true
          cwd: "<%= dirs.srcApp %>/scripts"
          src: ["**/*.coffee"]
          dest: "<%= dirs.buildApp %>/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "<%= dirs.srcTest %>"
          src: "**/*.coffee"
          dest: "<%= dirs.buildTest %>"
          ext: ".js"
        ]

      server:
        files: [
          expand: true
          cwd: "<%= dirs.srcServer %>"
          src: "**/*.coffee"
          dest: "<%= dirs.buildServer %>"
          ext: ".js"
        ]

      initjsforintellij:
        files: [
          expand: true
          cwd: "<%= dirs.srcApp %>/scripts"
          src: ["init.coffee"]
          dest: "<%= dirs.srcApp %>/scripts/"
          ext: ".js"
        ]
        options:
          sourceMap: false

    coffeelint:
      options:
        max_line_length:
          value: 180

      dev: [
        "<%= dirs.srcApp %>/scripts/**/*.coffee"
      ]
      test: [
        "<%= dirs.srcTest %>/**/*.coffee"
      ]
      server: [
        "<%= dirs.srcServer %>/**/*.coffee"
      ]

    bowerRequirejs:
      app:
        rjsConfig: "<%= dirs.buildApp %>/scripts/init.js"
        options:
          transitive: true
          exclude: ['i18next']
      test:
        rjsConfig: "<%= dirs.buildTest %>/SpecRunner.js"
        options:
          transitive: true
          exclude: ['i18next']

    requirejs:
      dist:
        options:
          baseUrl: "<%= dirs.buildApp %>/scripts"
          mainConfigFile: "<%= dirs.buildApp %>/scripts/init.js"
          wrapShim: true
          optimize: "uglify2"
          useStrict: true
          pragmasOnSave:
            excludeHbsParser: true
            excludeHbs: true
            excludeAfterBuild: true
          findNestedDependencies: true
          removeCombined: false
          include: [
            "<%= dirs.bowerComponents %>/requirejs/require"
          ]
          out: "<%= dirs.dist %>/scripts/main.js"
          wrap: true
          preserveLicenseComments: true
          logLevel: 0

      bundle:
        options:
          baseUrl: "<%= dirs.buildApp %>/scripts"
          include: [ 'lib/bundle' ]
          exclude: [ 'i18next', 'rivets', 'underscore', 'underscore.string', 'sightglass' ]
          optimize: "none"
          out: "<%= dirs.dist %>/backbone.marionette.component.js"
          name: '<%= dirs.bowerComponents %>/almond/almond',
          mainConfigFile: "<%= dirs.buildApp %>/scripts/lib/mainConfig.js"
          logLevel: 0

      bundleMinify:
        options:
          baseUrl: "<%= dirs.buildApp %>/scripts"
          include: [ 'lib/bundle' ]
          exclude: [ 'i18next', 'rivets', 'underscore', 'underscore.string', 'sightglass' ]
          optimize: "uglify2"
          out: "<%= dirs.dist %>/backbone.marionette.component.min.js"
          name: '<%= dirs.bowerComponents %>/almond/almond',
          mainConfigFile: "<%= dirs.buildApp %>/scripts/lib/mainConfig.js"
          logLevel: 0
    less:
      dev:
        options:
          paths: ["<%= dirs.buildApp %>/styles"]

        files: [
          "<%= dirs.buildApp %>/styles/main.css": "<%= dirs.buildApp %>/styles/main.less"
        ]

      dist:
        options:
          paths: ["<%= dirs.buildApp %>/styles"]

        files: [
          "<%= dirs.dist %>/styles/main.css": "<%= dirs.buildApp %>/styles/main.less"
        ]

    autoprefixer:
      options:
        map: true
        browsers: ["last 3 versions", "ie 8", "ie 9", "ie 10", "ie 11"]

      dev:
        files:
          "<%= dirs.buildApp %>/styles/main.css": "<%= dirs.buildApp %>/styles/main.css"

      dist:
        files:
          "<%= dirs.dist %>/styles/main.css": "<%= dirs.dist %>/styles/main.css"


    express:
      options:
        args: [
          "localhost"
        ]

      dev:
        options:
          script: "<%= dirs.buildServer %>/server.js"
          port: "<%= ports.dev %>"
          node_env: 'dev'

      test:
        options:
          script: "<%= dirs.buildServer %>/server.js"
          port: "<%= ports.test %>"
          node_env: 'test'

      dist:
        options:
          script: "<%= dirs.buildServer %>/server.js"
          port: "<%= ports.dist %>"
          node_env: 'dist'

  # open app for development
    open:
      dev:
        path: "http://localhost:<%= ports.dev %>"

      dist:
        path: "http://localhost:<%= ports.dist %>"

    preprocess:
      dist:
        options:
          context:
            BUILD: true

        src: "<%= dirs.srcApp %>/index.html"
        dest: "<%= dirs.dist %>/index.html"

      dev:
        options:
          context:
            BUILD: false

        src: "<%= dirs.buildApp %>/index.html"
        dest: "<%= dirs.buildApp %>/index.html"

    mocha:
      test:
        options:
          urls: [ "http://localhost:<%= ports.test%>" ],

    blanket_mocha:
      test:
        options:
          urls: [ "http://localhost:<%= ports.test%>" ],
          threshold: 90


    grunt.registerTask 'default', ->
      grunt.option 'force', true
      grunt.task.run [
        'clean'
        'compile'
        'express:dev'
        'express:test'
        'blanket_mocha'
        'open:dev'
        'watch'
      ]

    grunt.registerTask 'compile', [
      'copy:dev'
      'copy:test'
      'less:dev'
      'autoprefixer:dev'
      'coffee:dev'
      'coffee:initjsforintellij'
      'coffee:test'
      'coffee:server'
      'coffeelint:dev'
      'coffeelint:server'
      'preprocess:dev'
      'bowerRequirejs'
    ]

    grunt.registerTask 'dist', [
      'copy:dist'
      'less:dist'
      'autoprefixer:dist'
      'requirejs:dist'
      'preprocess:dist'
      'requirejs:bundle'
      'requirejs:bundleMinify'
    ]

    grunt.registerTask 'run:dev', [
      'express:dev'
      'open:dev'
      'watch'
    ]

    grunt.registerTask 'run:dist', [
      'express:dist'
      'open:dist'
      'watch:dist'
    ]

    grunt.registerTask 'build', [
      'clean'
      'compile'
      'dist'
      'express:test'
      'blanket_mocha'
    ]

  return
