
class Store.views.Button extends Backbone.View
  events:
    'click': 'onClick'

  constructor: (options) ->
    super(options)
    @actionFn = options.actionFn
    @spinner  = new Store.views.Spinner
    @html    = @$el.html()
    @loading = @$el.attr('data-loading') || 'Czekaj'

  fire: =>
    promise = @actionFn()
    if promise?
      @lock()
      promise.always(@unlock)

  lock: =>
    @$el.html(@loading)
    @loadingTimeout = setTimeout(@showLoading, 500)
    @disable()

  unlock: =>
    @hideLoading()
    @enable()

  # private

  onClick: (e) ->
    e.preventDefault()
    @fire()

  showLoading: =>
    i = 1
    dots = $('<span>.</span>').css(position: 'absolute').appendTo(@$el)
    @loadingInterval = setInterval =>
      dots.html(_.str.repeat('.', i % 3 + 1))
      i += 1
    , 300

  hideLoading: =>
    @$el.html(@html)
    clearTimeout(@loadingTimeout)
    clearInterval(@loadingInterval)

  disable: =>
    @$el.prop('disabled', true)

  enable: =>
    @$el.prop('disabled', false)
