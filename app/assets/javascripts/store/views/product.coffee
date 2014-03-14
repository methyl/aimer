class Store.views.Product extends Backbone.View
  tagName: 'li'
  template: HandlebarsTemplates['store/templates/product']

  attributes: ->
    'class': 'product'
    'data-id': @product.get('id')

  events:
    'keyup input[name=quantity]': 'handleQuantityKeyup'
    'click input[name=quantity]': 'handleQuantityClick'

  BACKSPACE_CODE = 8

  constructor: (@product, @order) ->
    super(arguments)

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
      slide: (e, ui) =>
        @$('input[name=quantity]').val(ui.value)
      stop: (e, ui) =>
        @setQuantity(ui.value)

  setQuantity: (quantity) ->
    quantity = Math.min(parseInt(quantity, 10), 50)
    @$('input[name=quantity]').val(quantity)
    if quantity > 0
      if @order.hasProduct(@product)
        @getLineItem().save({ quantity: quantity }, wait: true)
      else
        @order.addProduct(@product, quantity: quantity)
    else
      @order.removeProduct(@product)

  handleQuantityKeyup: _.debounce (e) ->
    @setQuantity(0) if e.keyCode == BACKSPACE_CODE
    @setQuantity($(e.currentTarget).val())
  , 300

  handleQuantityClick: (e) =>
    $(e.currentTarget).select()
