class Store.views.Application extends Backbone.View
  template: HandlebarsTemplates['store/templates/application']

  constructor: ->
    super()
    @pageHeader = new Store.views.PageHeader
    @pageFooter = new Store.views.PageFooter
    @viewSwitcher = new Store.views.ViewSwitcher
    $(window).on 'scroll', @onScroll

  render: =>
    @$el.html(@template())
    @assignSubview @pageHeader, '[data-subview=page-header]'
    @assignSubview @pageFooter, '[data-subview=page-footer]'
    @assignSubview @viewSwitcher, '[data-subview=view-switcher]'
    @initializeParallax()
    @

  getView: ->
    @view

  # private

  showView: (view, options) ->
    @view = view
    @viewSwitcher.setView(view, options)

  initializeParallax: =>
    @parallelObjects = []
    for el in @$('[data-parallax]')
      $el = $(el)
      factor = parseFloat($(el).data('parallax-factor') ? 1)
      @parallelObjects.push { $el, factor }

  onScroll: =>
    for obj in @parallelObjects
      top = $(window).scrollTop() / obj.factor
      obj.$el.css(transform: "translate3d(0, #{top}px, 0)")
