class Store.models.LineItem extends Backbone.Model
  constructor: (models, options) ->
    @order = options.order
    super(models, options)

  queryString: ->
    "?order_token=#{@order.get('token')}"

  toJSON: ->
    line_item: super()

  increaseQuantity: (quantity) ->
    quantity = parseInt(quantity)
    quantity += @get('quantity')
    @set('quantity', quantity)
    @

class Store.models.LineItems extends Backbone.Collection
  model: Store.models.LineItem

  constructor: (models, options) ->
    @order = options.order
    super(models, options)

  add: (items, options = {}) ->
    _.extend(options, {order: @order})
    items = [items] unless items.length
    for item in items
      if existingItem = @getItemByVariantId(item.variant_id)
        existingItem.increaseQuantity(item.quantity)
      else
        super(item, options)

  queryString: ->
    "?order_token=#{@order.get('token')}"

  url: ->
    @order.url() + '/line_items'

  getItemByVariantId: (variantId) ->
    @find (item) -> item.get('variant').id == variantId
