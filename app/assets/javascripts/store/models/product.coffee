class Store.models.Product extends Backbone.Model

class Store.models.Products extends Backbone.Collection
  model: Store.models.Product
  url: '/spree/api/products'

  constructor: (attributes, options = {}) ->
    options.parse = true unless options.parse?
    super(attributes, options)

  parse: (response) ->
    response.products

  comparator: (a, b) ->
    weight1 = parseFloat(a.get('master').weight)
    weight2 = parseFloat(b.get('master').weight)
    n = weight1 - weight2
    if n != 0
      return n

    pcs1 = parseInt(a.get('master').depth)
    pcs2 = parseInt(b.get('master').depth)
    return pcs1 - pcs2
