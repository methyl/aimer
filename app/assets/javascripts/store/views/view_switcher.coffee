class Store.views.ViewSwitcher extends Backbone.View
  template: '<div data-current></div>'

  constructor: (initial) ->
    super
    @currentView = initial

  render: =>
    @$el.html(@template)
    @assignSubview @currentView, '[data-current]'
    @

  setView: (view) ->
    @currentView?.remove()
    @currentView = view
    @render()
