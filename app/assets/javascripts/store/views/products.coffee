class Store.views.Products extends Backbone.View
  template: HandlebarsTemplates['store/templates/products']
  totalTemplate: HandlebarsTemplates['store/templates/products/total']
  className: 'products'

  events:
    'click ul.products [data-id]': 'handleProductClick'

  constructor: ->
    super(arguments)
    @products = new Store.models.Products
    @order = Store.currentUser.getOrder()

    @presenter = new Store.presenters.Order(@order)

    @order.on 'change', @renderTotal
    @order.on 'change:number', @render
    @productViews = []
    @load()

  render: =>
    @$el.html(@template())
    @renderTotal()
    @addProducts()
    @

  load: ->
    $.when(@products.fetch()).then =>
      @render()
      @trigger('change:height', @$el.outerHeight())

  # private

  renderTotal: =>
    @$('[data-template=total]').html(@totalTemplate(@presenter.toJSON()))

  addProducts: ->
    view.remove() for view in @productViews
    @productViews = []
    @addProduct(product) for product in @products.models

  addProduct: (product) =>
    view = new Store.views.Product(product, @order)
    view.render().$el.appendTo(@$('ul.products'))
    @productViews.push(view)
