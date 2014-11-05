"use strict"

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # show elapsed time at the end
  require("time-grunt") grunt

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
        options:
          livereload: true

      static:
        files: [
          "<%= dirs.srcApp %>/templates/{,**/}*.hbs"
          "<%= dirs.srcApp %>/images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        tasks: ["newer:copy:dev"]
        options:
          livereload: true

      coffeeApp:
        files: ["<%= dirs.srcApp %>/scripts/{,**/}*.coffee"]
        tasks: ["newer:coffee:dev"]
        options:
          livereload: true

      coffeeInitJsForIntelliJ:
        files: ["<%= dirs.srcApp %>/scripts/init.coffee"]
        tasks: ["newer:coffee:initjsforintellij"]
        options:
          livereload: true

      coffeeTest:
        files: ["<%= dirs.srcTest %>/{,**/}*.coffee"]
        tasks: ["newer:coffee:test"]
        options:
          livereload: true

      coffeeServer:
        files: ["<%= dirs.srcServer %>/{,**/}*.coffee"]
        tasks: ["newer:coffee:server"]
        options:
          livereload: true

      less:
        files: ["<%= dirs.srcApp %>/styles/{,**/}*.less"]
        tasks: [
          "newer:copy:dev"
          "less:dev"
        ]
        options:
          livereload: true

      test:
        files: [
          "<%= dirs.buildTest %>/{,**/}*.js"
        ]
        tasks: ["exec:mocha"]

      dist:
        files: ["<%= dirs.dist %>"]


  # copying all kind of files - no processing
    copy:
      dev:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= dirs.srcApp %>"
            dest: "<%= dirs.buildApp %>"
            src: [
              "*.html"
              "templates/**"
              "*.{ico,txt}"
              ".htaccess"
              "styles/**"
              "images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
            ]
          }
          {
            expand: true
            dot: true
            cwd: "bower_components"
            dest: "<%= dirs.buildApp %>/bower_components"
            src: ["**"]
          }
        ]

      test:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= dirs.srcTest %>"
            dest: "<%= dirs.buildTest %>"
            src: ["index.html"]
          }
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
            "images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}"
          ]
        ]
    coffee:
      options:
        sourceMap: true

      dev:
        files: [
          expand: true
          cwd: "<%= dirs.srcApp %>/scripts"
          src: ["**/*.coffee"]
          dest: "<%= dirs.buildApp %>/scripts"
          ext: ".js"
        ]

      initjsforintellij:
        sourceMap: false
        files: [
          expand: true
          cwd: "<%= dirs.srcApp %>/scripts"
          src: ["init.coffee"]
          dest: "<%= dirs.srcApp %>/scripts/"
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

    coffeelint:
      options:
        max_line_length:
          value: 180

      dev: ["<%= dirs.srcApp %>/scripts/**/*.coffee"]
      test: ["<%= dirs.srcTest %>/**/*.coffee"]
      server: ["<%= dirs.srcServer %>/**/*.coffee"]


    requirejs:
      dist:
        options:
          baseUrl: "<%= dirs.buildApp %>/scripts"
          mainConfigFile: "<%= dirs.buildApp %>/scripts/init.js"
          paths:
            templates: "templates"

          wrapShim: true
          optimize: "uglify"
          useStrict: true
          pragmasOnSave:
            excludeHbsParser: true
            excludeHbs: true
            excludeAfterBuild: true

          findNestedDependencies: true
          removeCombined: false
          include: ["../bower_components/requirejs/require"]
          out: "<%= dirs.dist %>/scripts/main.js"
          wrap: true
          preserveLicenseComments: false
          onBuildRead: (moduleName, path, contents) ->
            # remove all console logs
            contents.replace(/console\.log\((.*)\);?/g, "")

          logLevel: 0
    less:
      dev:
        options:
          paths: ["<%= dirs.buildApp %>/styles"]

        files:
          "<%= dirs.buildApp %>/styles/main.css": "<%= dirs.buildApp %>/styles/main.less"

      dist:
        options:
          paths: ["<%= dirs.buildApp %>/styles"]

        files:
          "<%= dirs.buildApp %>/styles/main.css": "<%= dirs.buildApp %>/styles/main.less"

    htmlmin:
      dist:
        options: {}
        files: [
          expand: true
          cwd: "<%= dirs.srcApp %>"
          src: "*.html"
          dest: "<%= dirs.dist %>"
        ]

    cssmin:
      dist:
        options:
          keepSpecialComments: "0"

        files:
          "<%= dirs.dist %>/styles/main.css": ["<%= dirs.buildApp %>/styles/{,*/}*.css"]

    useminPrepare:
      html: "<%= dirs.srcApp %>/index.html"
      options:
        staging: "<%= dirs.build %>/staging"
        dest: "<%= dirs.dist %>"

    usemin:
      html: ["<%= dirs.dist %>/{,*/}*.html"]
      css: ["<%= dirs.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= dirs.dist %>"]


    express:
      options:
        args: [
          "localhost"
          "<%= ports.api %>"
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


  # mocha command
    exec:
      mocha:
        command: "mocha-phantomjs http://localhost:<%= ports.test %>/test"
        stdout: true


  # open app for development
    open:
      dev:
        path: "http://localhost:<%= ports.dev %>"

      dist:
        path: "http://localhost:<%= ports.dist %>"


  # linting
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "Gruntfile.js"
        "<%= dirs.srcApp %>/scripts/{,*/}*.js"
        "test/spec/{,*/}*.js"
      ]


  # preprocess
    csslint:
      options:
        csslintrc: ".csslintrc"
        formatters: [
          {
            id: "junit-xml"
            dest: "report/csslint_junit.xml"
          }
          {
            id: "csslint-xml"
            dest: "report/csslint.xml"
          }
        ]

      strict:
        options:
          import: 2

        src: ["<%= dirs.buildApp %>/styles/main.css"]

      lax:
        options:
          import: false

        src: ["<%= dirs.buildApp %>/styles/main.css"]

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


  # starts express server with live testing via testserver
  grunt.registerTask "default", ->
    grunt.option "force", true
    grunt.task.run [
      "clean"
      "compile"
      "express:dev"
      "test:dev"
      "open:dev"
      "watch"
    ]

  grunt.registerTask "compile", [
    "copy:dev"
    "copy:test"
    "less:dev"
    "coffee:dev"
    "coffee:initjsforintellij"
    "coffee:test"
    "coffee:server"
    "coffeelint:dev"
    "coffeelint:server"
    "preprocess:dev"
  ]

  grunt.registerTask "test:dev", [
    "express:test"
    "exec:mocha"
  ]

  grunt.registerTask "test:dist", [
    "express:test"
    "exec:mocha"
    "express:dist"
  ]

  grunt.registerTask "dist", [
    "less:dist"
    "useminPrepare"
    "requirejs"
    "copy:dist"
    "htmlmin"
    "concat"
    "cssmin"
    "replace:dist"
    "preprocess:dist"
    "usemin"
    "uglify:generated"
  ]

  grunt.registerTask "run:dev", [
    "express:dev"
    "open:dev"
    "watch"
  ]

  grunt.registerTask "run:dist", [
    "express:dist"
    "open:dist"
    "watch:dist"
  ]

  grunt.registerTask "build", [
    # no clean inside build tasks! this task is meant to be used from gradle and gradle will execute clean separately
    "compile"
    "dist"
    "test:dist"
  ]

  return
