class InfinitePage
  constructor: (@container) ->
    @nearBottom = 350
    @container.attr 'data-infinite-paged', true
    @container.addClass 'infinite_page'
    @scrollEvent = @generateScrollEvent()
    @ajax = null
    @page = 1
    @loadNextPageIfNearBottom()
    @watchDistanceFromBottom()
  
  # Generate a unique 'namespaced' scroll event so it can be bound to
  # the window without conflicting with other infinite scroll elements.  
  generateScrollEvent: ->
    hash = $.md5 @container.text() + new Date().getTime().toString()
    "scroll.infinite:#{hash}"

  distanceFromBottom: ->
    $(document).height() - $(window).height() - $(window).scrollTop()

  loadNextPageIfNearBottom: =>
    if @distanceFromBottom() < @nearBottom
      if @container.css 'display'
        @loadNextPage()
      else
        @stop()

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
        @stop() unless $.trim data
        @container.append data
        @page++
      error: =>
        @stop()

  watchDistanceFromBottom: =>
    throttled = _.throttle =>
      @loadNextPageIfNearBottom()
    , 100
    $(window).bind @scrollEvent, throttled

  stop: =>
    @container.removeClass 'infinite_page'
    $(window).unbind @scrollEvent

  
$(document).bind 'pageUpdated', ->
  $('[data-behavior~=infinite_page]:not([data-infinite-paged])').each ->
    new InfinitePage $(this)