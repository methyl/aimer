class Store.models.Checkout extends Backbone.Model
  urlRoot: '/api/checkouts'

  constructor: (attrs, options = {}) ->
    super(attrs, options)
    @order = options.order

  advanceStep: =>
    @sync.call(@, 'put', @, {
      url: "#{@url()}/next",
      method: 'put'
    })

  updateAddress: (address) ->
    @save(order: { bill_address_attributes: address, ship_address_attributes: address })

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

  toJSON: ->
    attrs = super()
    _.omit(attrs, 'token')
