class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @initializeSkrollr()

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @currentView, '[data-subview=current-view]' if @currentView
    @waitForDom(@refreshSkrollr)
    @

  # private

  showView: (view) ->
    @currentView = view
    @render()

  initializeSkrollr: =>
    @skrollr = skrollr.init({
      easing: 0
      smoothScrolling: false
      forceHeight: false
    })

  refreshSkrollr: =>
    @skrollr.refresh()

  waitForDom: (fn) =>
    setTimeout(fn, 0)
