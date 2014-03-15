class Store.views.PageFooter extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_footer']
  className: 'page-footer'

  constructor: ->
    super

  render: ->
    @$el.html(@template())
    @

