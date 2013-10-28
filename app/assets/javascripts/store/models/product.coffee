class Store.models.Product extends Backbone.Model
  isInCart: ->
    !! @getLineItem()

  getLineItem: ->
    Store.currentOrder.getLineItems().getItemByVariantId(@get('variants')[0].id)

class Store.models.Products extends Backbone.Collection
  model: Store.models.Product
  url: '/api/products'

  comparator: 'name'

  constructor: (attributes, options = {}) ->
    options.parse = true unless options.parse?
    super(attributes, options)

  parse: (response) ->
    response.products

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
