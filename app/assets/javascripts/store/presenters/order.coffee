class Store.presenters.Order
  constructor: (order) ->
    @order = order

  toJSON: ->
    json = @order.toJSON?() ? @order
    json.formatted_total = @formatPrice(json.total)
    json.formatted_ship_total = @formatPrice(json.ship_total)
    json.line_items = @lineItems()
    json.selected_shipping_rate = json.shipments?[0]?.selected_shipping_rate
    json.shipping_free = @order.isShippingFree()
    json

  # private

  lineItems: ->
    @order.get('line_items')?.map (lineItem) ->
      new Store.presenters.Product(lineItem).toJSON()

  formatPrice: (price) ->
    fixed = parseFloat(price).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    whole + ',' + rest + ' pln'
