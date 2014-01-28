class Store.presenters.Products
  constructor: (order) ->
    @order = order.toJSON().order

  toJSON: ->
    {
      total: @total()
    }

  # private

  total: ->
    fixed = parseFloat(@order.total).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    if rest == '00'
      whole + ' pln'
    else
      whole + '.' + rest + ' pln'
