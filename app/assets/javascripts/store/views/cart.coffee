class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  constructor: ->
    super(arguments)
    @order = Store.currentOrder
    @listenTo @order, 'change', @render

    @load()

  render: =>
    @$el.html(@template(order: @order.toJSON(), lineItems: @order.getLineItems()?.toJSON()))
    @

  # private

  load: =>
    @order.load().done(@render)
