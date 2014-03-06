class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @header = new Store.views.Header

  render: =>
    @$el.html(@template())
    @assignSubview @header, '[data-subview=header]'
    @assignSubview @currentView, '[data-subview=current-view]' if @currentView
    @

  showView: (view) ->
    @currentView = view
    @render()
