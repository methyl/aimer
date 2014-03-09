class Store.models.LineItem extends Backbone.Model
  constructor: (models, options) ->
    @order = options.order
    super(models, options)

  sync: ->
    arguments[2].success = (resp) =>
      @order.set(@order.parse(resp))
    Backbone.sync.apply(this, arguments)

  queryString: ->
    "?order_token=#{@order.get('token')}"

  increaseQuantity: (quantity) ->
    quantity = parseInt(quantity)
    quantity += @get('quantity')
    @set('quantity', quantity)
    @

  paramRoot: 'line_item'

class Store.models.LineItems extends Backbone.Collection
  model: Store.models.LineItem

  constructor: (models, options) ->
    @order = options.order
    super(models, options)

  create: (item, options = {}) ->
    _.extend(options, {order: @order})
    super(item, options)

  add: (items, options = {}) ->
    _.extend(options, {order: @order})
    items = [items] unless items.length
    for item in items
      item = new Store.models.LineItem(item, order: @order) unless item.get?
      if existingItem = @getItemByVariantId(item.get('variant_id'))
        existingItem.save({ quantity: item.get('quantity') }, wait: true)
      else
        super(item, options)

  queryString: ->
    "?order_token=#{@order.get('token')}"

  url: ->
    @order.url() + '/line_items'

  getItemByVariantId: (variantId) ->
    @find (item) -> item.get('variant_id') == variantId
