class Store.views.Checkout.Payment extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/payment']
  className: 'checkout-payment'

  events:
    'click [data-role=next-payment]': 'updatePayment'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()
    @cart = new Store.views.Cart(@checkout)

  render: =>
    if @isLoaded()
      @$el.html(@template(order: new Store.presenters.Order(@order).toJSON()))
      @assignSubview(@cart, '[data-subview=cart]')
    @

  getPayment: ->
    { payment_method_id: @order.get('payment_methods')[0].id }

  # private

  updatePayment: ->
    @checkout.updatePayment(@getPayment()).then(@proceed)

  proceed: =>
    @trigger('proceed')

  isLoaded: ->
    @order.get('payment_methods')?[0]
