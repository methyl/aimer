class Store.presenters.Product
  constructor: (@product) ->

  toJSON: ->
    json = @product.toJSON()
    variant = json.variant || json.variants[0]
    {
      id: json.id
      name: variant.name
      description: variant.description
      round_pln_price: parseInt(variant.price, 10) + ' pln'
      weight: parseFloat(variant.weight).toFixed(2) + ' g'
      quantity: json.quantity || 0
      pcs: parseInt(variant.depth, 10) + ' pcs'
    }
