class Store.views.Products extends Backbone.View
  template: HandlebarsTemplates['store/templates/products']
  className: 'products'

  events:
    'click ul.products [data-id]': 'handleProductClick'

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: ->
    super(arguments)
    @order = Store.currentOrder
    @products = new Store.models.Products
    @load()

  render: =>
    @$el.html(@template())
    @addProduct(product) for product in @products.models
    @

  load: ->
    $.when(@order.fetch(), @products.fetch()).then(@render)

  # private

  addProduct: (product) =>
    view = new Store.views.Product(product)
    view.render().$el.appendTo(@$('ul.products'))

  handleProductClick: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    product = @products.get(el.data('id'))
    if product.isInCart()
      @removeFromCart(product)
    else
      @addToCart(product)

  addToCart: (product) =>
    @order.addProduct(product)

  removeFromCart: (product) =>
    @order.removeProduct(product)
