class Store.models.Checkout extends Backbone.Model
  urlRoot: '/api/checkouts'

  constructor: (attrs, options = {}) ->
    super(attrs, options)
    @order = options.order
    @listenTo @order, 'change', =>
      @attributes = @order.attributes
    @on 'change', =>
      @order.attributes = @parse(@toJSON())
      @order.trigger('change')

  getOrder: ->
    @order

  advanceStep: =>
    $.ajax
      url: @url() + '/next'
      type: 'PUT'
    .then =>
      @fetch()

  updateAddressAndEmail: (address, email) ->
    @save(order: { email: email, bill_address_attributes: address, ship_address_attributes: address })

  updateShipment: (shipment) ->
    @save(order: { shipments_attributes: shipment })

  updatePayment: (payment) ->
    @save(order: {
      payments_attributes: payment,
      payment_source: {
        1: {
          number: '1'
          name: 'John Smith'
          expiry: '05/2018'
          verification_value: '123'
        }
      }
    })

  updateEmail: (email) ->
    @save(order: { email: email })

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
