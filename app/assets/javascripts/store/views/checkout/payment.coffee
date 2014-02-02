class Store.views.Checkout.Payment extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/payment']
  className: 'checkout-payment'

  events:
    'click form.payment input[type=radio]': 'handlePaymentChange'

  constructor: (@order) ->
    super(arguments)
    @listenTo @order, 'change', @render

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

  handlePaymentChange: ->
    @trigger('change:payment', @getPayment())

  isLoaded: ->
    @order.get('payment_methods')?[0]
