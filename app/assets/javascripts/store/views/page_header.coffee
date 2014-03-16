class Store.views.PageHeader extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header']
  className: 'page-header'

  constructor: ->
    super
    @top = new Store.views.PageHeader.Top

  render: ->
    @$el.html(@template())
    @assignSubview(@top, '[data-subview=top]')
    @
