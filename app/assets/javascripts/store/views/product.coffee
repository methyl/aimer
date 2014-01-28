class Store.views.Product extends Backbone.View
  tagName: 'li'
  template: HandlebarsTemplates['store/templates/product']

  attributes: ->
    'class': 'product'
    'data-id': @product.get('id')

  constructor: (@product, @order) ->
    super(arguments)
    @listenTo @order, 'change', @render
    @listenTo @product, 'add-to-cart', @render
    @listenTo @product, 'remove-from-cart', @onRemoveFromCart

  render: (item) =>
    @$el.html(@template(
      product: @product.toJSON()
      lineItem: @getLineItem()?.toJSON()
    ))
    @initializeSlider()
    @

  # private

  getLineItem: ->
    @order.getLineItemForProduct(@product)

  initializeSlider: ->
    @$('.slider').slider
      min: 0
      max: 4
      value: @getLineItem()?.get('quantity') || 0
      stop: (e, ui) =>
        if ui.value > 0
          if @order.hasProduct(@product)
            @getLineItem().save({ quantity: ui.value }, wait: true)
          else
            @order.addProduct(@product, quantity: ui.value)
        else
          @order.removeProduct(@product)

