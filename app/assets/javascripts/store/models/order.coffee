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
    attrs.line_items = new Store.models.LineItems(attrs.line_items, order: @)
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
