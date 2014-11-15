# Based on http://blog.ninebyt.es/outsourcing-your-authentication-with-hull-io/

define ['https://d3f5pyioow99x0.cloudfront.net/0.8.43/hull.js'], (hullib) ->
  class HullService

    @$inject: ['$log']
    constructor: (@log) ->
      @log.info('Created hull!!!!')
      @user = null
      @loadingMessage = ''
      @loading = true

    init: (@config) ->
      @setupHullEvents()
      # FIXME - understand how to use config
      @config =
        loadingMessage: null

      if @config.loadingMessage then @loadingMessage = @config.loadingMessage

      @log.info('Initing hull!!!!')
      Hull.init
        debug: true
        appId: "5462c12028d1a19515000ea7"
        orgUrl: "https://9beb919e.hullapp.io"
        accessToken: "FIXME"
      , (hull) =>
        @resetLoader()
      @log.info("Done init")


    setupHullEvents: =>
      Hull.on 'hull.auth.login', (@user) => @resetLoader()

      Hull.on 'hull.auth.logout', =>
        @user = null
        @resetLoader()

      Hull.on 'hull.auth.fail', =>
        @resetLoader()
        #TODO: Output a message to the user

      Hull.on 'hull.init', (@hull, @user) => @resetLoader()


    login: (provider) ->
      @setLoader @config.loggingInMessage
      Hull.login provider


    logout: =>
      setLoader @config.loggingOutMessage
      Hull.logout()

    setLoader: (message) ->
      @loadingMessage = message
      @loading = true


    resetLoader: =>
      # FIXME - may need apply here!
      #@scope.$apply() =>
      @log.info("Hull init complete...")
      #@loadingMessage = ''
      #@loading = false

  module = angular.module('app')
  module.service 'hullService', HullService
