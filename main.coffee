app = require "app"
BrowserWindow = require "browser-window"
require("crash-reporter").start()
mainWindow = null
app.on 'window-all-closed', -> app.quit() if process.platform isnt "darwin"
app.on 'ready', ->
  mainWindow = new BrowserWindow
    width: 600
    height: 200
    frame: false
    transparent: true
  mainWindow.loadUrl "file://#{__dirname}/index.html"
  mainWindow.on "closed", -> mainWindow = null
