class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @viewSwitcher = new Store.views.ViewSwitcher
    @initializeSkrollr()# unless @isVieportSmall()

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
    $(window).on 'scroll', (e) ->
      el = $('.background')
      top = $(window).scrollTop() / 3.5
      el.css(transform: "translate3d(0, #{top}px, 0)")

    # @skrollr = skrollr.init({
    #   easing: 0
    #   smoothScrolling: false
    #   forceHeight: false
    #   mobileCheck: -> false
    # })

  refreshSkrollr: =>
    @skrollr.refresh() unless @isVieportSmall()

  waitForDom: (fn) =>
    setTimeout(fn, 0)

  isVieportSmall: ->
    window.innerWidth < 950
