class Store.views.ViewSwitcher extends Backbone.View
  template: '
    <div data-subview="current"></div>
  '
  className: 'view-switcher'

  render: =>
    @$el.html(@template)
    @assignSubview @currentView, '[data-subview=current]' if @currentView
    @

  setView: (view, options = {}) ->
    @previousView = @currentView
    @currentView = view

    @listenTo @currentView, 'change:height', @updateHeight unless options.persistHeight

    if options.animate and @previousView? and @previousView != view
      @$el.append('<div data-subview="next"></div>')
      @assignSubview @currentView, '[data-subview=next]'
      @transitionViews(options.direction)
    else
      @previousView?.remove()
      @$el.html(@template)
      @assignSubview @currentView, '[data-subview=current]'

  # private

  updateHeight: (height) =>
    @$el.height(height)

  transitionViews: (direction = 'left') ->
    @isAnimated = true
    $next    = @$('[data-subview=next]')
    $current = @$('[data-subview=current]')

    $next.show()
    if direction == 'left'
      @moveEl($next, 'left')
      @moveEl($current, 'right', true)
    else
      @moveEl($next, 'right')
      @moveEl($current, 'left', true)
    @moveEl($next, 'normal', true)

    setTimeout =>
      @previousView.remove()
      $next.attr('data-subview', 'current')
      @isAnimated = false
    , 500

  moveEl: ($el, position, animate = false) ->
    if position == 'left'
      left = -($el.width() + $el.offset().left)
    else if position == 'normal'
      left = 0
    else
      left = window.innerWidth
    method = if animate then 'animate' else 'css'
    $el[method] ({ left })
