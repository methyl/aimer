class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  constructor: (options = {}) ->
    super(options)
    @order = options.order

    @listenTo @order, 'change', @render

  render: =>
    @$el.html(@template(order: new Store.presenters.Order(@order).toJSON()))
    @
