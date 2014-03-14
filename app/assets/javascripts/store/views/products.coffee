class Store.views.Products extends Backbone.View
  template: HandlebarsTemplates['store/templates/products']
  className: 'products'

  events:
    'click ul.products [data-id]': 'handleProductClick'

  constructor: ->
    super(arguments)
    @products = new Store.models.Products
    @order = Store.currentUser.getOrder()

    @order.on 'change', @render
    @productViews = []
    @load()

  render: =>
    @$el.html(@template(new Store.presenters.Order(@order).toJSON()))
    @addProducts()
    @

  load: ->
    $.when(@products.fetch()).then(@render)

  # private

  addProducts: ->
    view.remove() for view in @productViews
    @productViews = []
    @addProduct(product) for product in @products.models

  addProduct: (product) =>
    view = new Store.views.Product(product, @order)
    view.render().$el.appendTo(@$('ul.products'))
    @productViews.push(view)
