path = require 'path'
fs = require 'fs'

getChromeDriverUrl = ->
  url = false
  urlBase = 'https://s3.amazonaws.com/node-webkit/v0.9.0/chromedriver2-nw-v0.9.0-'
  if process.platform is 'darwin'
    url = urlBase + 'osx-ia32.zip'
  else if process.platform is 'win32'
    url = urlBase + 'win-ia32.zip'
  else if process.arch is 'ia32'
    url = urlBase + 'linux-ia32.tar.gz'
  else if process.arch is 'x64'
    url = urlBase + 'linux-x64.tar.gz'
  url
    
download = (url, dest, grunt, options, done, error) ->
  download = require 'download'
  progressBar = require 'progress'
  bar = undefined
  total = progress = 0
  d = download url, dest, options
  
  d.on 'response', (res) ->
    total = parseInt res.headers['content-length'], 10
    bar = new progressBar "downloading chromedriver [:bar] :percent :etas",
      complete: '='
      incomplete: '-'
      width: 20
      total: total
    
  d.on 'data', (data) ->
    bar.tick data.length
    if bar.complete
      grunt.log.writeln 'Extracting...'
        
  d.on 'error', (err) -> error err
    
  d.on 'close', ->
    process.nextTick ->
      fs.rename path.join(dest, 'chromedriver2_server' + if process.platform is 'win32' then '.exe' else ''), path.join(dest, 'chromedriver' + if process.platform is 'win32' then '.exe' else ''), (err) ->
        if err then done false else do done

module.exports = (grunt, done) ->
  dest = path.resolve do process.cwd, 'node_modules/nodewebkit/nodewebkit'
  fs.stat path.join(dest, 'chromedriver' + if process.platform is 'win32' then '.exe' else ''), (err) ->
    if err
      url = do getChromeDriverUrl
      if !url
        grunt.log.error 'Could not determine architecture of current platform. Aborting...'
        done false
      else
        download url, dest, grunt,
          extract: yes
          strip: 1
        , done
        , (error) ->
          grunt.log.error if typeof error is 'string' then error else error.message
          done false
    else
      do done