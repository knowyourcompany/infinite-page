class InfinitePage
  constructor: (@container) ->
    @nearBottom = 350
    @container.attr 'data-infinite-paged', true
    @container.addClass 'infinite_page'
    @ajax = null
    @page = 1
    @loadNextPageIfNearBottom()
    @watchDistanceFromBottom()

  distanceFromBottom: ->
    $(document).height() - $(window).height() - $(window).scrollTop()

  loadNextPageIfNearBottom: =>
    if @distanceFromBottom() < @nearBottom
      @loadNextPage()

  loadNextPage: =>
    return if @ajax and @ajax.readyState < 4 and @ajax.readyState > 0
    
    @container.addClass 'busy'
    @ajax = $.ajax 
      type: 'GET'
      dataType: 'html'
      url: "#{window.location.pathname}.js"
      data: { @page }
      success: (data) =>
        @container.removeClass 'busy'
        @stop() unless data
        @container.append data
        @page++

  watchDistanceFromBottom: =>
    throttled = _.throttle =>
      @loadNextPageIfNearBottom()
    , 100
    $(document).bind 'scroll.infinite', throttled

  stop: =>
    @container.removeClass 'infinite_page'
    $(document).unbind 'scroll.infinite'

   
$(document).bind 'pageUpdated', ->
  $('[data-behavior~=infinite_page]:not([data-infinite-paged])').each ->
    new InfinitePage $(this)