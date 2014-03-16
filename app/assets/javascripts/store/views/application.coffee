class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @viewSwitcher = new Store.views.ViewSwitcher
    @initializeSkrollr()

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @viewSwitcher, '[data-subview=view-switcher]'
    @waitForDom(@refreshSkrollr)
    @

  # private

  showView: (view) ->
    @viewSwitcher.setView(view)

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
