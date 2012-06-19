path = require 'path'
logger =   require './logger'

class MimosaDefaults

  fatalErrors: 0

  applyAndValidateDefaults: (config, callback) =>
    config = @_applyDefaults(config)
    @_validateDefaults(config)
    err = if @fatalErrors is 0 then null else @fatalErrors
    callback(err, config)

  _applyDefaults: (config) ->
    newConfig = {}
    newConfig.watch = config.watch ?= {}
    newConfig.watch.originationDir = config.watch.originationDir ?= "assets"
    newConfig.watch.destinationDir = config.watch.destinationDir ?= "public"
    newConfig.watch.ignored = config.watch.ignored ?= [".sass-cache"]

    comp = newConfig.compilers = config.compilers ?= {}
    js = comp.javascript = config.compilers.javascript ?= {}
    js.compileWith =     config.compilers.javascript.compileWith ?= "coffee"
    js.extensions =      config.compilers.javascript.extensions ?= ["coffee"]
    js.notifyOnSuccess = config.compilers.javascript.notifyOnSuccess ?= true

    template = comp.template = config.compilers.template ?= {}
    template.compileWith = config.compilers.template.compileWith ?= "handlebars"
    template.extensions = config.compilers.template.extensions ?= ["hbs", "handlebars"]
    template.outputFileName = config.compilers.template.outputFileName ?= "javascripts/templates"
    template.defineLocation = config.compilers.template.defineLocation ?= "vendor/handlebars"
    template.helperFile = config.compilers.template.helperFile ?= "javascripts/handlebars-helper"
    template.notifyOnSuccess = config.compilers.template.notifyOnSuccess ?= true

    css = comp.css = config.compilers.css ?= {}
    css.compileWith = config.compilers.css.compileWith ?= "sass"
    css.extensions = config.compilers.css.extensions ?= ["scss", "sass"]
    css.hasCompass = config.compilers.css.hasCompass ?= true
    css.notifyOnSuccess = config.compilers.css.notifyOnSuccess ?= true

    copy = newConfig.copy = config.copy ?= {}
    copy.extensions = config.copy.extensions ?= ["js","css","png","jpg","jpeg","gif"]
    copy.notifyOnSuccess = config.copy.notifyOnSuccess ?= false

    server = newConfig.server = config.server ?= {}
    server.path = config.server.path ?= 'server.coffee'
    server.port = config.server.port ?= 4321
    server.base = config.server.base ?= '/app'

    newConfig

  _validateDefaults: (config) ->
    @_pathExists(config.watch.originationDir, "originationDir")
    @_pathExists(config.watch.originationDir, "destinationDir")

  _pathExists: (filePath, name) ->
    rPath = path.resolve filePath
    rPathExists = path.existsSync rPath
    unless rPathExists
      logger.fatal "#{name} cannot be found"
      @fatalErrors++

module.exports = (new MimosaDefaults()).applyAndValidateDefaults