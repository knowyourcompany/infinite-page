#= require jquery
#= require underscore

class InfinitePage
  @install: (container, options) ->
    unless $(container).data "infinitePage"
      new this container, options
      $(container).data "infinitePage", true

  constructor: (container, @options = {}) ->
    @$container = $(container).addClass 'infinite_page'
    @options.triggerDistance ?= 350
    @ajax = null
    @page = 2
    @done = false
    if @options.immediate?
      @loadAll()
    else
      @loadNextPageIfNearBottom()
      @watchDistanceFromBottom()

  loadAll: ->
    @loadNextPage cb = =>
      @loadNextPage(cb) unless @done

  distanceFromBottom: ->
    $(document).height() - $(window).height() - $(window).scrollTop()

  loadNextPageIfNearBottom: =>
    if @distanceFromBottom() < @options.triggerDistance
      if @$container.is ':visible'
        @loadNextPage()
      else
        @stop()

  loadNextPage: (callback) =>
    return if @ajax and @ajax.readyState < 4 and @ajax.readyState > 0

    @$container.addClass('busy').trigger 'infinite_page:start'
    @ajax = $.ajax
      type: 'GET'
      dataType: 'html'
      url: "#{window.location.pathname}.js#{window.location.search}"
      data: { @page }
      success: (data) =>
        @$container.removeClass 'busy'
        @stop() unless $.trim data
        @$container.append(data).trigger 'infinite_page:load'
        @page++
        callback?()
      error: =>
        @stop()

  watchDistanceFromBottom: =>
    @throttledLoadNextPageIfNearBottom = _.throttle =>
      @loadNextPageIfNearBottom()
    , 100
    $(window).bind 'scroll', @throttledLoadNextPageIfNearBottom

  stop: =>
    @done = true
    @$container.removeClass('infinite_page busy').trigger 'infinite_page:stop'
    $(window).unbind 'scroll', @throttledLoadNextPageIfNearBottom if @throttledLoadNextPageIfNearBottom?


$.fn.infinitePage = (options) ->
  @each ->
    InfinitePage.install this, options
