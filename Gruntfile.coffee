module.exports = (grunt) ->

  grunt.initConfig

    clean:
      all:
        options:
          force: yes
        src: 'build'

    coffee       :
      all        :
        options  :
          bare   : yes
        files    : [
          expand : yes
          cwd    : 'public'
          src    : ['**/*.coffee']
          dest   : 'build/js/'
          ext    : '.js'
        ]

    coffee2closure:
      all:
        files: [
          expand: yes
          src: 'public/**/*.coffee'
          ext: '.js'
        ]

    templates:
      all:
        src: 'public/**/*.soy'

    deps:
      all:
        options:
          outputFile: 'build/deps.js'
          prefix: '../../../../'
          root: [
            'bower_components/closure-library'
            'bower_components/closure-templates'
            'public'
          ]

    tests:
      app:
        options:
          depsPath: '<%= deps.all.options.outputFile %>'
          prefix: '<%= deps.all.options.prefix %>'
        src: 'public/**/*_test.js'

    builder:
      options:
        root: '<%= deps.all.options.root %>'
        depsPath: '<%= deps.all.options.outputFile %>'
        compilerFlags: [
          '--output_wrapper="(function(){%output%})();"'
          '--compilation_level="ADVANCED_OPTIMIZATIONS"'
          '--warning_level="VERBOSE"'
          '--define=goog.net.XmlHttp.ASSUME_NATIVE_XHR=true'
          # '--define=public.json.SUPPORTS_NATIVE_JSON=true'
          '--define=goog.style.GET_BOUNDING_CLIENT_RECT_ALWAYS_EXISTS=true'
          '--define=goog.DEBUG=false'
        ]

      all:
        options:
          namespace: '*'
          outputFilePath: 'build/all.js'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-closure-coffee-stack'
  grunt.loadNpmTasks 'grunt-npm'

  grunt.registerTask 'test', ->
    grunt.task.run [
      'clean'
      'coffee'
      'coffee2closure'
      'templates'
      'deps'
      'tests'
      'builder'
    ]

  grunt.registerTask 'default', 'Build app and run stack.', (app = 'app') ->
    grunt.task.run [
      'clean'
      'coffee'
      # 'coffee2closure'
      # 'templates'
      # 'deps'
      # 'builder'
    ]