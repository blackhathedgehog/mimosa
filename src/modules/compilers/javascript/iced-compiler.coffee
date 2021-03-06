"use strict"

iced = require 'iced-coffee-script'
JSCompiler = require "./javascript"

module.exports = class IcedCompiler extends JSCompiler

  @prettyName        = "Iced CoffeeScript - http://maxtaco.github.com/coffee-script/"
  @defaultExtensions = ["iced"]

  constructor: (config, @extensions) ->
    @icedConfig = config.iced
    super()

  registration: (config, register) ->
    super config, register
    @_cleanUpSourceMapsRegister register, @extensions, @icedConfig

  compile: (file, cb) ->
    @_icedAndCoffeeCompile file, cb, @icedConfig, iced