class InfinitePage
  @install: (container) ->
    unless $(container).data "infinitePage"
      new this container
      $(container).data "infinitePage", true

  constructor: (container) ->
    @$container = $(container)
    @nearBottom = 350
    @$container.addClass 'infinite_page'
    @ajax = null
    @page = 1
    @loadNextPageIfNearBottom()
    @watchDistanceFromBottom()

  distanceFromBottom: ->
    $(document).height() - $(window).height() - $(window).scrollTop()

  loadNextPageIfNearBottom: =>
    if @distanceFromBottom() < @nearBottom
      if @$container.css 'display'
        @loadNextPage()
      else
        @stop()

  loadNextPage: =>
    return if @ajax and @ajax.readyState < 4 and @ajax.readyState > 0

    @$container.addClass 'busy'
    @ajax = $.ajax
      type: 'GET'
      dataType: 'html'
      url: "#{window.location.pathname}.js"
      data: { @page }
      success: (data) =>
        @$container.removeClass 'busy'
        @stop() unless $.trim data
        @$container.append data
        @page++
      error: =>
        @stop()

  watchDistanceFromBottom: =>
    @throttledLoadNextPageIfNearBottom = _.throttle =>
      @loadNextPageIfNearBottom()
    , 100
    $(window).bind 'scroll', @throttledLoadNextPageIfNearBottom

  stop: =>
    @$container.removeClass 'infinite_page'
    $(window).unbind 'scroll', @throttledLoadNextPageIfNearBottom


$.fn.infinitePage = ->
  @each ->
    InfinitePage.install this
