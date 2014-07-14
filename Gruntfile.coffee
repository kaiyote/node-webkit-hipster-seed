module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON '_public/package.json'
    nodeunit:
      all: ['test/unit/**/*.coffee']
      options:
        reporter: 'nested'
    nodewebkit:
      options:
        version: "0.9.2"
        build_dir: './dist'
        # specifiy what to build
        mac: false
        win: true
        linux32: false
        linux64: false
      src: './_public/**/*'

  grunt.loadNpmTasks 'grunt-node-webkit-builder'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'

  grunt.registerTask 'default', ['nodewebkit']