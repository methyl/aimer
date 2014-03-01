class Store.views.Checkout.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/cart']
  className: 'checkout-cart'

  events:
    'click .without-account button': 'handleWithoutLoginClick'

  constructor: (@order) ->
    super(arguments)
    @listenTo @order, 'change', @render

    @load()

  render: =>
    @$el.html(@template(order: @order.toJSON()))
    @

  getEmail: =>
    @$('form.without-account [name=email]').val()

  # private

  load: =>
    @order.load().done(@render)

  handleWithoutLoginClick: (e) ->
    e.preventDefault()
    @trigger('click:process-without-account')
