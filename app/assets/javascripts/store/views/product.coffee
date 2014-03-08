class Store.views.Product extends Backbone.View
  tagName: 'li'
  template: HandlebarsTemplates['store/templates/product']

  attributes: ->
    'class': 'product'
    'data-id': @product.get('id')

  events:
    'keyup input[name=quantity]': 'handleQuantityKeyup'
    'click input[name=quantity]': 'handleQuantityClick'

  constructor: (@product, @order) ->
    super(arguments)
    @listenTo @order, 'change', @render
    @listenTo @product, 'add-to-cart', @render
    @listenTo @product, 'remove-from-cart', @onRemoveFromCart

  render: (item) =>
    @$el.html(@template(
      new Store.presenters.Product(@getLineItem() || @product).toJSON()
    ))
    @initializeSlider()
    @

  # private

  getLineItem: ->
    @order.getLineItemForProduct(@product)

  initializeSlider: ->
    @$('.slider').slider
      min: 0
      max: 5
      value: @getLineItem()?.get('quantity') || 0
      stop: (e, ui) =>
        @$('input[name=quantity]').val(ui.value)
        @setQuantity(ui.value)

  setQuantity: (quantity) ->
    qunatity = parseInt(quantity, 10)
    if quantity > 0
      if @order.hasProduct(@product)
        @getLineItem().save({ quantity: quantity }, wait: true)
      else
        @order.addProduct(@product, quantity: quantity)
    else
      @order.removeProduct(@product)

  handleQuantityKeyup: _.debounce (e) ->
    @setQuantity($(e.currentTarget).val())
  , 300

  handleQuantityClick: (e) =>
    $(e.currentTarget).select()
