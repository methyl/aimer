class Store.views.Checkout.Shipping extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/shipping']
  className: 'checkout-shipping'

  events:
    'click form.shipping input[type=radio]': 'handleShipmentChange'
    'click [data-role=next-shipping]': 'proceed'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()
    @cart = new Store.views.Cart(@checkout)
    @listenTo @order, 'change', @render

    @load()

  render: =>
    if @isLoaded()
      @$el.html(@template(
        shippingRates: new Store.presenters.ShippingRates(@order.get('shipments')[0].shipping_rates).toJSON()
        shippingFree: @order.isShippingFree()
      ))
      @assignSubview(@cart, '[data-subview=cart]')
      @checkCurrentShippingRate()
    @

  getShipment: ->
    {
      selected_shipping_rate_id: @$('form input:checked').val()
      id: @order.get('shipments')[0].id
    }

  # private

  proceed: ->
    if @order.get('shipments')[0].selected_shipping_rate
      if @order.get('state') == 'delivery'
        @checkout.advanceStep().then => @trigger('proceed')
      else
        @trigger('proceed')

  handleShipmentChange: ->
    @checkout.updateShipment(@getShipment())

  checkCurrentShippingRate: ->
    id = @order.get('shipments')[0].selected_shipping_rate.id
    @$("input[name=shipping_rate_id][value=#{id}]").prop('checked', true)

  load: =>
    @order.fetch().done(@render)

  isLoaded: ->
    @order.get('shipments')?[0]
