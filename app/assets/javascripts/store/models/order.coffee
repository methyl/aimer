class Store.models.Order extends Backbone.Model
  urlRoot: '/api/orders'
  idAttribute: 'number'

  constructor: (attributes, options = {}) ->
    options.parse = true unless options.parse?
    super(attributes, options)
    if order = @getFromLocalStorage()
      @set('number', order.number)
      @set('token', order.token)

  parse: (args...) ->
    attrs = super(args...)
    if attrs.line_items?
      attrs.line_items = new Store.models.LineItems((if attrs.line_items.length > 0 then attrs.line_items else null), order: @)
    attrs

  toJSON: ->
    json = super()
    json.line_items = json.line_items.toJSON() if json.line_items?
    json

  save: ->
    super(arguments).done(@saveToLocalStorage)

  url: ->
    if @isNew()
      @urlRoot
    else
      @urlRoot + '/' + @id

  queryString: ->
    "?order_token=#{@get('token')}" unless @isNew()

  getLineItems: ->
    @get('line_items')

  addLineItem: (item) ->
    @getLineItems().add(item)[0].save()

  addProduct: (product, quantity = 1) ->
    @addLineItem({ variant_id: product.get('variants')[0].id, quantity: quantity })
      .then(=> @fetch())
      .done(=> product.trigger('add-to-cart'))

  removeProduct: (product) ->
    @getLineItems().getItemByVariantId(product.get('variants')[0].id).destroy(wait: true)
      .then(=> @fetch())
      .done(=> product.trigger('remove-from-cart'))

  # private

  getLineItemsUrl: ->
    @urlRoot + '/' + @id + '/line_items'

  getFromLocalStorage: ->
    number = localStorage.AimerStoreOrderNumber
    token  = localStorage.AimerStoreOrderToken
    if number and token
      { number, token }

  saveToLocalStorage: =>
    localStorage.AimerStoreOrderNumber = @get('number')
    localStorage.AimerStoreOrderToken = @get('token')
