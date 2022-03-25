#= require underscore

class InfinitePage
  @install: (container, options) ->
    unless $(container).data "infinitePageInstalled"
      new this container, options
      $(container).data "infinitePageInstalled", true

  constructor: (container, @options = {}) ->
    @$container = $(container).addClass 'infinite_page'
    @options.triggerDistance ?= 350
    @options.localScroll ?= false

    if @options.localScroll
      @$scrollContainer = $(@$container.parents('[data-infinite-page-target=container]')[0])
      @scrollHeight = @$scrollContainer.height()
    else
      @$scrollContainer = $(window)
      @scrollHeight = $(document).height()

    @setPage @$container.attr "data-infinite-page" ? @options.page
    @ajax = null
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
    @scrollHeight - @$scrollContainer.height() - @$scrollContainer.scrollTop()

  loadNextPageIfNearBottom: =>
    if $.contains(document, @$container[0])
      if @distanceFromBottom() < @options.triggerDistance and @$container.is ':visible'
        @loadNextPage()
    else
      @stop()

  setPage: (page = 2) ->
    @page = parseInt page
    @$container.attr "data-infinite-page", @page

  loadNextPage: (callback) =>
    return if @ajax and @ajax.readyState < 4 and @ajax.readyState > 0

    @$container.addClass('busy').trigger 'infinite_page:start'
    @ajax = $.ajax
      type: 'GET'
      dataType: 'html'
      url: @options.url ? "#{window.location.pathname}.js#{window.location.search}"
      data: $.extend { @page }, @options.data ? {}
      success: (data) =>
        @$container.removeClass 'busy'
        @stop() unless $.trim data
        @$container.append(data).trigger 'infinite_page:load'
        @setPage @page + 1
        callback?()
      error: =>
        @stop()

  watchDistanceFromBottom: =>
    @throttledLoadNextPageIfNearBottom = _.throttle =>
      @loadNextPageIfNearBottom()
    , 100
    @$scrollContainer.on 'scroll', @throttledLoadNextPageIfNearBottom

  stop: =>
    @done = true
    @$container.removeClass('infinite_page busy').trigger 'infinite_page:stop'
    @$scrollContainer.off 'scroll', @throttledLoadNextPageIfNearBottom if @throttledLoadNextPageIfNearBottom?

$.fn.infinitePage = (options) ->
  @each ->
    InfinitePage.install this, options
