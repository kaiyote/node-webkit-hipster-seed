path = require 'path'
webdriver = require 'selenium-webdriver'

getPathSep = ->
  if process.platform is 'win32' then ';' else ':'

driverPath = path.resolve do process.cwd, 'node_modules/nodewebkit/nodewebkit'
appUrl = 'file:///' + path.resolve do process.cwd, '_public/index.html'
process.env.path += do getPathSep + driverPath

exports['E2E App Tests'] =
  setUp: (callback) ->
    @driver = new webdriver.Builder().withCapabilities(webdriver.Capabilities.chrome()).build()
    @driver.get(appUrl).then ->
      do callback
    
  'Can navigate to application entry point': (test) ->
    driver.getTitle().then (title) ->
      test.equal 'Todo', title, 'The title is correct'
      do test.done