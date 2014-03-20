class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @viewSwitcher = new Store.views.ViewSwitcher
    @initializeSkrollr() unless @isVieportSmall()

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @viewSwitcher, '[data-subview=view-switcher]'
    @waitForDom(@refreshSkrollr)
    @

  getView: ->
    @view

  # private

  showView: (view, options) ->
    @view = view
    @viewSwitcher.setView(view, options)

  initializeSkrollr: =>
    @skrollr = skrollr.init({
      easing: 0
      forceHeight: false
      mobileCheck: -> false
    })

  refreshSkrollr: =>
    @skrollr.refresh() unless @isVieportSmall()

  waitForDom: (fn) =>
    setTimeout(fn, 0)

  isVieportSmall: ->
    window.innerWidth < 950
