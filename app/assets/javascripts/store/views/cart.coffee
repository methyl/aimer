class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()

    @listenTo @order, 'add reset change', @render

  render: =>
    @$el.html(@template(order: new Store.presenters.Order(@order).toJSON()))
    @
