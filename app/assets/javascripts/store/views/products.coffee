class Store.views.Products extends Backbone.View
  template: HandlebarsTemplates['store/templates/products']
  className: 'products'

  events:
    'click ul.products [data-id]': 'handleProductClick'

  constructor: (@order) ->
    super(arguments)
    @products = new Store.models.Products

    @order.on 'change', @render
    @load()

  render: =>
    @$el.html(@template(new Store.presenters.Order(@order).toJSON()))
    @addProduct(product) for product in @products.models
    @

  load: ->
    $.when(@products.fetch()).then(@render)

  # private

  addProduct: (product) =>
    view = new Store.views.Product(product, @order)
    view.render().$el.appendTo(@$('ul.products'))
