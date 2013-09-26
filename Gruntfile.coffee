module.exports = (grunt)->
  grunt.initConfig
    clean: ["bin", 'test-bin']
    livescript:
      src:
        files: [
          expand: true
          flatten: true
          cwd: 'src'
          src: ['**/*.ls']
          dest: 'bin/'
          ext: '.js'
        ]
      test:
        files: [
          expand: true 
          flatten: true
          cwd: 'test'
          src: ['**/*.ls']
          dest: 'bin/'
          ext: '.js'
        ]
    watch:
      all:
        files: ["src/**/*.ls", "test/**/*.ls"]
        tasks: ["livescript"]
        options:
          spawn: true
          livereload: true
      server:
        files: ["bin/*.js"]
        # tasks: ["http-server"]
        options:
          spawn: true
          livereload: true
    'http-server':
      all:
        root: '.'
        port: 8282
        host: '127.0.0.1'
        showDir: true
        autoIndex: true
        defaultExt: 'html'
        runInBackground: true
    concurrent:
      target: 
        tasks:
          ['http-server', 'watch']
        options:
          logConcurrentOutput: true

  grunt.loadNpmTasks "grunt-livescript"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-http-server"

  grunt.registerTask "default", ["clean", "livescript", "watch"]


  grunt.event.on 'watch', (action, filepath)->
    console.log 'filepath: ', filepath
    grunt.config ['livescript', 'src'], filepath
    grunt.config ['livescript', 'test'], filepath