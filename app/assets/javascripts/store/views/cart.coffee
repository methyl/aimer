class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  constructor: (options = {}) ->
    super(options)

  render: =>
    @$el.html(@template())
    @
