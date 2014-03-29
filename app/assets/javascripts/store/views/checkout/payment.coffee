class Store.views.Checkout.Payment extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/payment']
  className: 'checkout-payment'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()
    @cart = new Store.views.Cart(@checkout)

  render: =>
    if @isLoaded()
      @$el.html(@template(order: new Store.presenters.Order(@order).toJSON()))
      @attachButtons()
      @assignSubview(@cart, '[data-subview=cart]')
    @

  getPayment: ->
    { payment_method_id: @order.get('payment_methods')[0].id }

  # private

  proceed: ->
    order = _.clone(@order)
    number = @order.get('number')
    @checkout.updatePayment(@getPayment())
      .then => @order.reload()
      .then => @trigger('proceed', order, number)

  isLoaded: ->
    @order.get('payment_methods')?[0]
