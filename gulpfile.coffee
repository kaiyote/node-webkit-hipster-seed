gulp = require 'gulp'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
maps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'
ignore = require('gulp-ignore').exclude
rename = require 'gulp-rename'
glob = require 'glob'
stylus = require 'gulp-stylus'
livereload = require 'gulp-livereload'
gulpif = require 'gulp-if'
argv = require('yargs').argv
minHtml = require 'gulp-minify-html'
minJs = require 'gulp-uglify'
minCss = require 'gulp-minify-css'
require 'colors'

condition = /(.*?[\/\\]+)?[_]\w*/
isProduction = argv.p?

errHandler = (err) ->
  console.log err.message.red
  @emit 'end'

gulp.task 'static-jade', ->
  gulp.src 'app/*.static.jade'
      .pipe ignore condition
      .pipe jade
        pretty: yes
        locals: {isDev: not isProduction}
      .on 'error', errHandler
      .pipe gulpif isProduction, do minHtml
      .pipe rename (path) ->
        path.basename = path.basename.replace '.static', ''
        return
      .pipe gulp.dest '_public/'
      .pipe do livereload

gulp.task 'app.js', ->
  gulp.src 'app/**/*.coffee'
      .pipe ignore condition
      .pipe gulpif not isProduction, do maps.init
      .pipe coffee
        bare: yes
      .on 'error', errHandler
      .pipe concat 'app.js'
      .pipe gulpif isProduction, do minJs
      .pipe gulpif not isProduction, maps.write '.'
      .pipe gulp.dest '_public/js'
      .pipe do livereload

gulp.task 'static-assets', ->
  gulp.src 'app/assets/**/*.*', {base: 'app/assets'}
      .pipe gulp.dest '_public'
      .pipe do livereload

gulp.task 'vendor.js', ->
  glob 'bower_components/*/bower.json', null, (er, files) ->
    configs = []
    configs.push require "./#{file}" for file in files
    gulp.src(
      configs.filter (elm) -> elm.main.match /.js$/
            .map (elm) -> "bower_components/#{elm.name}/#{elm.main.replace '.min', ''}"
    )
        .pipe gulpif not isProduction, do maps.init
        .pipe concat 'vendor.js'
        .pipe gulpif isProduction, do minJs
        .pipe gulpif not isProduction, maps.write '.'
        .pipe gulp.dest '_public/js'
        .pipe do livereload

gulp.task 'css', ->
  gulp.src 'app/**/*.styl'
      .pipe ignore condition
      .pipe do stylus
      .on 'error', errHandler
      .pipe concat 'app.css'
      .pipe gulpif isProduction, do minCss
      .pipe gulp.dest '_public/css'
      .pipe do livereload

gulp.task 'build', ->
  version = require('./package.json').devDependencies.nodewebkit.slice 1
  NW = require 'node-webkit-builder'
  nw = new NW
    files: './_public/**/**'
    platforms: ['win32', 'win64'] #tack on osx32, osx64, linux32, linux64 for your platform of choice
    version: version
  nw.on 'log', console.log

  nw.build()
    .then -> console.log 'build complete'
    .catch (err) -> console.log err.red

gulp.task 'default', ['static-jade', 'app.js', 'static-assets', 'vendor.js', 'css'], ->
  livereload.listen
    port: 3000
    basePath: '_public'
  gulp.watch 'app/*.static.jade', ['static-jade']
  gulp.watch 'app/**/*.coffee', ['app.js']
  gulp.watch 'app/assets/**/*.*', ['static-assets']
  gulp.watch 'bower_components/*/bower.json', ['vendor.js']
  gulp.watch 'app/**/*.styl', ['css']
