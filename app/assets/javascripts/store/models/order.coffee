class Store.models.Order extends Backbone.Model
  urlRoot: '/spree/api/orders'
  idAttribute: 'number'

  NUMBER_COOKIE = 'aimer-order-number'
  TOKEN_COOKIE = 'aimer-order-token'

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
    # { order: json } unless _.isEmpty(json)

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
    @getLineItems().add(item)[0].save()

  addProduct: (product, options = {}) ->
    @addLineItem({ variant_id: product.get('master').id, quantity: options.quantity || 1 })
      .done(=> product.trigger('add-to-cart'))

  removeProduct: (product) ->
    @getLineItems().getItemByVariantId(product.get('master').id).destroy(wait: true)
      .done(=> product.trigger('remove-from-cart'))

  getLineItemForProduct: (product) ->
    @getLineItems()?.getItemByVariantId(product.get('master')?.id)

  hasProduct: (product) ->
    !! @getLineItemForProduct(product)

  clearCookies: ->
    $.removeCookie(NUMBER_COOKIE)
    $.removeCookie(TOKEN_COOKIE)

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
