class Store.views.Checkout.Payment extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/payment']
  className: 'checkout-payment'

  events:
    'click [data-role=next-payment]': 'updatePayment'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()

    @load()

  render: =>
    if @isLoaded()
      @$el.html(@template(paymentMethods: @order.toJSON().order.payment_methods))
    @

  load: =>
    @order.fetch().done(@render)

  getPayment: ->
    { payment_method_id: @$('form input:checked').val() }

  # private

  updatePayment: ->
    @checkout.updatePayment(@getPayment()).then(@proceed)

  proceed: =>
    @trigger('proceed')

  isLoaded: ->
    @order.get('payment_methods')?[0]
