class Store.presenters.Product
  constructor: (@product) ->

  toJSON: ->
    json = @product.toJSON()
    json.isInCart = @product.isInCart()
    json

class Store.presenters.Products
  constructor: (@products) ->

  toJSON: ->
    @products.models.map (product) -> new Store.presenters.Product(product).toJSON()
