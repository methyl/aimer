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

  render: =>
    if @isLoaded()
      @$el.html(@template(
        shippingRates: new Store.presenters.ShippingRates(@order.get('shipments')[0].shipping_rates).toJSON()
        shippingFree: @order.isShippingFree()
      ))
      @attachButtons()
      @assignSubview(@cart, '[data-subview=cart]')
      @checkCurrentShippingRate()
    @

  getShipment: ->
    {
      selected_shipping_rate_id: @$('form input:checked').val()
      id: @order.get('shipments')[0].id
    }

  # private

  triggerProceed: =>
    @trigger('proceed')

  proceed: ->
    if @order.get('shipments')[0].selected_shipping_rate
      if @order.get('state') == 'delivery'
        @checkout.advanceStep().then(@triggerProceed)
      else
        @triggerProceed()

  handleShipmentChange: ->
    @disableBtn()
    @cart.showSpinner()
    @checkout.updateShipment(@getShipment()).then(@enableBtn)

  checkCurrentShippingRate: ->
    id = @order.get('shipments')[0].selected_shipping_rate.id
    @$("input[name=shipping_rate_id][value=#{id}]").prop('checked', true)

  isLoaded: ->
    @order.get('shipments')?[0]

  disableBtn: =>
    @$('[data-action=proceed]').prop('disabled', true)

  enableBtn: =>
    @$('[data-action=proceed]').prop('disabled', false)
