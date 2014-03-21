class Store.views.Popup extends Backbone.View
  events:
    'click .overlay': 'hide'
    'click .modal': (e) -> e.stopPropagation()

  show: ->
    @render().$el.appendTo($('body'))
    @showPopup(animate: true)
    @setBodyProperties()
    @$('input').first().focus()

  hide: =>
    @remove()

  remove: =>
    @hidePopup(animate: true).then =>
      super
      @unsetBodyProperties()

  setBodyProperties: ->
    $('body').css(overflowY: 'scroll', height: window.innerHeight)

  unsetBodyProperties: ->
    $('body').css(overflow: 'auto', height: 'auto')

  hidePopup: (options = {}) ->
    if options.animate
      @showPopup()
    @movePopup(-@$('.modal').outerHeight(), options)

  showPopup: (options = {}) ->
    if options.animate
      @hidePopup()
    @movePopup(200, options)

  movePopup: (top, options = {} ) ->
    if options.animate
      @$('.modal').animate({ top }, 500, 'easeOutCubic').promise()
    else
      @$('.modal').css { top }
