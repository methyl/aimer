class Store.views.PageHeader extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header']
  className: 'page-header'

  events:
    'click [data-role=scroll-to-content]': 'scrollToContent'

  BOTTOM_SCROLL_MARGIN = 100

  constructor: ->
    super

  render: ->
    @$el.html(@template())
    @assignSubview(@top, '[data-subview=top]')
    @

  # private

  scrollToContent: (e) ->
    e.preventDefault()
    $('body').animate(scrollTop: @$el.height() - BOTTOM_SCROLL_MARGIN)
