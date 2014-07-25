path = require 'path'
fs = require 'fs'
async = require 'async'
dest = path.join do process.cwd, 'test'

getChromeDriverUrl = ->
  urlBase = 'http://chromedriver.storage.googleapis.com/2.10/chromedriver_'
  return urlBase + 'mac32.zip' if process.platform is 'darwin'
  return urlBase + 'win32.zip' if process.platform is 'win32'
  return urlBase + 'linux32.zip' if process.arch is 'ia32'
  return urlBase + 'linux64.zip' if process.arch is 'x64'
    
download = (target, url, dest, options, done, error) ->
  dl = require 'download'
  progressBar = require 'progress'
  bar = undefined
  d = dl url, dest, options
  
  d.on 'response', (res) ->
    total = parseInt res.headers['content-length'], 10
    bar = new progressBar "downloading #{target} [:bar] :percent :etas",
      complete: '='
      incomplete: '-'
      width: 20
      total: total
    
  d.on 'data', (data) ->
    bar.tick data.length
    console.log 'Extracting...' if bar.complete
        
  d.on 'error', (err) -> error err
    
  d.on 'close', -> process.nextTick -> do done

getChromeDriver = (done) ->
  fs.stat path.join(dest, 'chromedriver' + if process.platform is 'win32' then '.exe' else ''), (err) ->
    if err
      url = do getChromeDriverUrl
      if url
        download 'chromedriver', url, dest,
          extract: yes
          strip: 1
        , done
        , (error) ->
          done error
      else
        done 'Could not determine host architecture...'
    else
      do done
      
getSelenium = (done) ->
  fs.stat path.join(dest, 'selenium-server-standalone-2.42.2.jar'), (err) ->
    if err
      url = 'http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar'
      download 'selenium', url, dest,
        extract: no
        strip: 1
      , done
      , (error) ->
        done error
    else
      do done
      
async.waterfall [
  getChromeDriver
  getSelenium
], -> require 'nightwatch/bin/runner.js'