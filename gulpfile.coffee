gulp = require 'gulp'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
maps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'
ignore = require('gulp-ignore').exclude
rename = require 'gulp-rename'
glob = require 'glob'
stylus = require 'gulp-stylus'

condition = /(.*?[\/\\]+)?[_]\w*/

gulp.task 'static-jade', ->
  gulp.src 'app/*.static.jade'
      .pipe ignore condition
      .pipe jade {pretty: yes}
      .pipe rename (path) ->
        path.basename = path.basename.replace '.static', ''
        return
      .pipe gulp.dest '_public/'

gulp.task 'app.js', ->
  gulp.src 'app/**/*.coffee'
      .pipe ignore condition
      .pipe do maps.init
      .pipe coffee
        bare: yes
      .pipe concat 'app.js'
      .pipe maps.write '.'
      .pipe gulp.dest '_public/js'

gulp.task 'static-assets', ->
  gulp.src 'app/assets/**/*.*', {base: 'app/assets'}
      .pipe gulp.dest '_public'

gulp.task 'vendor.js', ->
  glob 'bower_components/*/bower.json', null, (er, files) ->
    configs = []
    configs.push require "./#{file}" for file in files
    gulp.src(
      configs.filter (elm) -> elm.main.match /.js$/
            .map (elm) -> "bower_components/#{elm.name}/#{elm.main.replace '.min', ''}"
    )
        .pipe do maps.init
        .pipe concat 'vendor.js'
        .pipe maps.write '.'
        .pipe gulp.dest '_public/js'

gulp.task 'css', ->
  gulp.src 'app/**/*.styl'
      .pipe ignore condition
      .pipe do stylus
      .pipe concat 'app.css'
      .pipe gulp.dest '_public/css'

gulp.task 'default', ['static-jade', 'app.js', 'static-assets', 'vendor.js', 'css'], ->
  gulp.watch 'app/*.static.jade', ['static-jade']
  gulp.watch 'app/**/*.coffee', ['app.js']
  gulp.watch 'app/assets/**/*.*', ['static-assets']
  gulp.watch 'bower_components/*/bower.json', ['vendor.js']
  gulp.watch 'app/**/*.styl', ['css']
