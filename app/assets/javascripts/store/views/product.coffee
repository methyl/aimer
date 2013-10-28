class Store.views.Product extends Backbone.View
  tagName: 'li'
  template: HandlebarsTemplates['store/templates/product']

  attributes: ->
    'class': 'product'
    'data-id': @product.get('id')

  constructor: (@product) ->
    super(arguments)
    @order = Store.currentOrder
    @listenTo @order, 'change', @render
    @listenTo @product, 'add-to-cart', @render
    @listenTo @product, 'remove-from-cart', @onRemoveFromCart

  render: (item) =>
    @$el.html(@template(
      product: @product.toJSON()
      lineItem: @product.getLineItem()?.toJSON()
    ))
    if @product.isInCart()
      @onAddToCart()
    @

  # private

  onAddToCart: ->
    @initializeSlider()
    @$el.removeClass('product').addClass('line-item')
    @listenTo @product.getLineItem(), 'change', @render

  onRemoveFromCart: ->
    @$el.addClass('product').removeClass('line-item')
    @render()

  initializeSlider: ->
    @$('.slider').slider
      min: 1
      max: 4
      value: @product.getLineItem().get('quantity')
      slide: (e, ui) =>
        @$('div.pictures').removeClass((i, klass) -> klass.match(/pictures-\d/)[0]).addClass("pictures-#{ui.value}")
      stop: (e, ui) =>
        @product.getLineItem().save({ quantity: ui.value }, wait: true)

