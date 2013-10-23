class Store.models.Product extends Backbone.Model

class Store.models.Products extends Backbone.Model
  url: '/api/products'

  # constructor: (models, options) ->
  #   @order = options.order
  #   super(models, options)

  # add: (items, options = {}) ->
  #   _.extend(options, {order: @order})
  #   super(items, options)

  # queryString: ->
  #   "?order_token=#{@order.get('token')}"

  # url: ->
  #   @order.url() + '/line_items'
