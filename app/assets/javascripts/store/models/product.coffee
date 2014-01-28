class Store.models.Product extends Backbone.Model

class Store.models.Products extends Backbone.Collection
  model: Store.models.Product
  url: '/api/products'

  comparator: 'name'

  constructor: (attributes, options = {}) ->
    options.parse = true unless options.parse?
    super(attributes, options)

  parse: (response) ->
    response.products
