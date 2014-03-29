class Store.models.Checkout extends Backbone.Model
  urlRoot: '/spree/api/checkouts'
  idAttribute: 'number'

  constructor: (attrs, options = {}) ->
    super(attrs, options)
    @order = Store.currentUser.getOrder()

    @listenTo @order, 'change', =>
      @attributes = @order.attributes
    @on 'sync', (model, resp) =>
      @order.attributes = @attributes
      @order.trigger('change')

  getOrder: ->
    @order

  advanceStep: =>
    @sync('update', @, url: @url() + '/next').then (data) =>
      @set(@parse(data))
      @order.attributes = @attributes
      @order.trigger('change')

  updateAddressAndEmail: (address, email) ->
    @save(order: { email: email, bill_address_attributes: address, ship_address_attributes: address })

  updateShipment: (shipment) ->
    @save(order: { shipments_attributes: shipment })

  updatePayment: (payment) ->
    @save(order: { payments_attributes: payment } )

  url: ->
    @urlRoot + '/' + @order.get('number')

  parse: (args...) ->
    attrs = super(args...)
    if attrs.line_items
      attrs.line_items = new Store.models.LineItems((if attrs.line_items.length > 0 then attrs.line_items else null), order: @)
    attrs

  toJSON: ->
    json = super()
    json.line_items = json.line_items.toJSON() if json.line_items?.toJSON?
    _.omit(json, 'token')
