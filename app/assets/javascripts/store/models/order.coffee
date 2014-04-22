class Store.models.Order extends Backbone.Model
  urlRoot: '/spree/api/orders'
  idAttribute: 'number'

  NUMBER_COOKIE = 'aimer-order-number'
  TOKEN_COOKIE = 'aimer-order-token'

  FREE_SHIPPING_FROM = 100

  constructor: (attributes, options = {}) ->
    options.parse = true unless options.parse?
    super(attributes, options)
    if order = @loadFromCookies()
      @set('number', order.number)
      @set('token', order.token)

  parse: (args...) ->
    attrs = super(args...)
    if attrs.line_items
      attrs.line_items = new Store.models.LineItems((if attrs.line_items.length > 0 then attrs.line_items else null), order: @)
    attrs

  toJSON: ->
    json = super()
    json.line_items = json.line_items.toJSON() if json.line_items?.toJSON?
    json = _.omit(json, 'token')
    json

  save: ->
    super(arguments).done(@saveCookies)

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
    @getLineItems().add(item)[0].save?()

  addProduct: (product, options = {}) ->
    @addLineItem({ variant_id: product.get('master').id, quantity: options.quantity || 1 })

  removeProduct: (product) ->
    @removeLineItem @getLineItems().getItemByVariantId(product.get('master').id)

  removeLineItem: (lineItem) ->
    lineItem.destroy(wait: true)

  getLineItemForProduct: (product) ->
    @getLineItemForProductId(product.get('master')?.id)

  getLineItemForProductId: (productId) ->
    @getLineItems()?.getItemByVariantId(productId)

  hasProduct: (product) ->
    !! @getLineItemForProduct(product)

  clearCookies: ->
    $.removeCookie(NUMBER_COOKIE)
    $.removeCookie(TOKEN_COOKIE)

  isShippingFree: ->
    @get('total') >= FREE_SHIPPING_FROM

  reload: =>
    @clearCookies()
    @set('number', null)
    @attributes = {}
    @save()

  # private

  getLineItemsUrl: ->
    @urlRoot + '/' + @id + '/line_items'

  loadFromCookies: =>
    number = $.cookie(NUMBER_COOKIE)
    token  = $.cookie(TOKEN_COOKIE)
    if number and token
      { number, token }

  saveCookies: =>
    $.cookie(NUMBER_COOKIE, @get('number'))
    $.cookie(TOKEN_COOKIE, @get('token'))
