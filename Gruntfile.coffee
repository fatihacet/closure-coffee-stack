module.exports = (grunt) ->

  grunt.initConfig

    clean            :
      all            :
        options      :
          force      : yes
        src          : 'build'

    mkdir            :
      all            :
        options      :
          create     : [
            'src/coffee'
            'src/externs'
            'src/images'
            'src/styl'
            'src/templates'
            'src/third-party'
            'build'
            'build/images'
          ]

    coffee           :
      all            :
        options      :
          bare       : yes
        files        : [
          expand     : yes
          cwd        : 'src/coffee'
          src        : ['**/*.coffee']
          dest       : 'build/js/'
          ext        : '.js'
        ]

    sprites          :
      all            :
        files        :
          src        : 'src/images'
          dest       : 'build/images'

    coffee2closure   :
      all            :
        files        : [
          expand     : yes
          src        : 'build/js/**/*.js'
          ext        : '.js'
        ]

    stylus           :
      options        :
        'include css': true
        'compress'   : false
      all            :
        files        : [
          expand     : true
          src        : [ '*.styl' ]
          ext        : '.css'
          cwd        : 'src/styl'
          dest       : 'build/css'
        ]

    templates        :
      all            :
        src          : 'src/templates/**/*.soy'
        dest         : 'build/templates/'

    deps             :
      all            :
        options      :
          outputFile : 'build/deps.js'
          prefix     : '../../../../'
          root       : [
            'bower_components/closure-library'
            'bower_components/closure-templates'
            'build'
          ]

    tests            :
      app            :
        options      :
          depsPath   : '<%= deps.all.options.outputFile %>'
          prefix     : '<%= deps.all.options.prefix %>'
        src          : 'build/js/**/*_test.js'

    builder              :
      all                :
        options          :
          namespace      : '*'
          outputFilePath : 'build/compiled.js'
      options            :
        root             : '<%= deps.all.options.root %>'
        depsPath         : '<%= deps.all.options.outputFile %>'
        compilerFlags    : [
          '--output_wrapper="(function(){%output%})();"'
          '--compilation_level="ADVANCED_OPTIMIZATIONS"'
          '--warning_level="VERBOSE"'
          '--externs=src/externs/externs.js'
          '--jscomp_error=accessControls'
          '--jscomp_error=checkRegExp'
          # '--formatting=PRETTY_PRINT'
          '--jscomp_error=checkTypes'
          '--jscomp_error=checkVars'
          '--jscomp_error=invalidCasts'
          '--jscomp_error=missingProperties'
          '--jscomp_error=nonStandardJsDocs'
          '--jscomp_error=strictModuleDepCheck'
          '--jscomp_error=undefinedVars'
          '--jscomp_error=unknownDefines'
          '--jscomp_error=visibility'
        ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-closure-coffee-stack'
  grunt.loadNpmTasks 'grunt-npm'

  grunt.registerTask 'test', 'Build stack with tests', ->
    grunt.task.run [
      'clean'
      'mkdir'
      'coffee'
      'coffee2closure'
      'stylus'
      'templates'
      'deps'
      'tests'
      'builder'
    ]

  grunt.registerTask 'default', 'Build stack.', (app = 'app') ->
    grunt.task.run [
      'clean'
      'mkdir'
      'sprites'
      'coffee'
      'coffee2closure'
      'stylus'
      'templates'
      'deps'
      'builder'
    ]