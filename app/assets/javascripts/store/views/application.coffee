class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @viewSwitcher = new Store.views.ViewSwitcher
    @initializeParallax()

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @viewSwitcher, '[data-subview=view-switcher]'
    @

  getView: ->
    @view

  # private

  showView: (view, options) ->
    @view = view
    @viewSwitcher.setView(view, options)

  initializeParallax: =>
    $(window).on 'scroll', (e) ->
      top = $(window).scrollTop() / 2.3
      $('.background').css(transform: "translate3d(0, #{top}px, 0)")
