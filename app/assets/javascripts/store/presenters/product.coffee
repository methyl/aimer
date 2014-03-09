class Store.presenters.Product
  constructor: (@product) ->

  toJSON: ->
    json = @product.toJSON()
    _.extend(json, json.variant)
    {
      id: json.id
      name: json.name
      description: json.description
      round_pln_price: parseInt(json.price, 10) + ' pln'
      total_pln_price: @total(json.price * json.quantity)
      weight: parseFloat(json.weight).toFixed(2) + ' g'
      quantity: json.quantity || 0
      pcs: parseInt(json.depth, 10) + ' pcs'
    }

  total: (price) ->
    fixed = parseFloat(price).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    if rest == '00'
      whole + ' pln'
    else
      whole + '.' + rest + ' pln'
