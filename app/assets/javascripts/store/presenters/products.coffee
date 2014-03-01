class Store.presenters.Order
  constructor: (order) ->
    @order = order

  toJSON: ->
    json = @order.toJSON().order
    json.total = @total()
    json.line_items = @lineItems()
    json

  # private

  lineItems: ->
    @order.get('line_items').map (lineItem) ->
      new Store.presenters.Product(lineItem).toJSON()

  total: ->
    fixed = parseFloat(@order.toJSON().order.total).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    if rest == '00'
      whole + ' pln'
    else
      whole + '.' + rest + ' pln'
