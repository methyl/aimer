class Store.presenters.Product
  constructor: (@product) ->

  toJSON: ->
    json = @product.toJSON()
    _.extend(json, json.variant || json.master)
    {
      id: json.id
      name: json.name
      description: json.description
      round_pln_price: parseInt(json.price, 10) + ' pln'
      display_price: @total(json.price)
      weight: parseFloat(json.weight).toFixed(2) + ' g'
      quantity: json.quantity || 0
      pcs: parseInt(json.depth, 10) + ' pcs'
    }

  total: (price) ->
    fixed = parseFloat(price).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    whole + ',' + rest
