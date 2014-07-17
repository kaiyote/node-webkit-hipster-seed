path = require 'path'
webdriver = require 'selenium-webdriver'

getPathSep = ->
  if process.platform is 'win32' then ';' else ':'

driverPath = path.resolve do process.cwd, 'node_modules/nodewebkit/nodewebkit'
appUrl = 'file:///' + path.resolve do process.cwd, '_public/index.html'
process.env.path += do getPathSep + driverPath
driver = new webdriver.Builder().withCapabilities(webdriver.Capabilities.chrome().merge({loggingPrefs: {driver: 'OFF'}})).build()
driver.executeScript 'window.resizeTo(850, 650)'

exports['E2E App Tests'] =
  setUp: (callback) ->
    driver.get(appUrl).then ->
      do callback
    
  'Should auto-load the Todo view when no fragment is passed in': (test) ->
    driver.getTitle().then (title) ->
      test.equal 'Todo', title, 'The title is correct'
      driver.getCurrentUrl().then (url) ->
        test.equal '#/todo', url.substring url.length - 6
        test.ok 'active', driver.findElement(webdriver.By.linkText 'todo').getAttribute 'class'
        do test.done
        
  'Should load #/route1 when the view1 link is clicked': (test) ->
    driver.findElement(webdriver.By.linkText 'view1').click().then ->
      test.ok 'active', driver.findElement(webdriver.By.linkText 'view1').getAttribute 'class'
      do test.done
      
  'Todo Tests':
    'Should list two items': (test) ->
      driver.findElements(webdriver.By.css 'ul.list-unstyled li').then (elements) ->
        test.equal 2, elements.length
        do test.done