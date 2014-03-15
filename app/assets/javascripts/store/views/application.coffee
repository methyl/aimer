class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @currentView, '[data-subview=current-view]' if @currentView
    @

  showView: (view) ->
    @currentView = view
    @render()
