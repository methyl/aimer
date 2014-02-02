class Store.views.Checkout.Shipping extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/shipping']
  className: 'checkout-shipping'

  events:
    'click form.shipping input[type=radio]': 'handleShipmentChange'

  constructor: (@order) ->
    super(arguments)
    @listenTo @order, 'change', @render

    @load()

  render: =>
    if @isLoaded()
      @$el.html(@template(shippingRates: @order.get('shipments')[0].shipping_rates))
      @checkCurrentShippingRate()
    @

  getShipment: ->
    {
      selected_shipping_rate_id: @$('form input:checked').val()
      id: @order.get('shipments')[0].id
    }

  # private

  handleShipmentChange: ->
    @trigger('change:shipment', @getShipment())

  checkCurrentShippingRate: ->
    id = @order.get('shipments')[0].selected_shipping_rate.id
    @$("input[name=shipping_rate_id][value=#{id}]").prop('checked', true)

  load: =>
    @order.fetch().done(@render)

  isLoaded: ->
    @order.get('shipments')?[0]
