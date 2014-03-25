class Store.views.Popup extends Backbone.View
  events:
    'click .modal': (e) -> e.stopPropagation()
    'click .overlay': 'hide'

  show: ->
    @render().$el.appendTo($('body'))
    @showPopup(animate: true).then =>
      @$('input').first().focus()

  hide: =>
    @remove()

  remove: =>
    @hidePopup(animate: true).then =>
      super

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
