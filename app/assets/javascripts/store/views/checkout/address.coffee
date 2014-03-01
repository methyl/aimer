class Store.views.Checkout.Address extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/address']
  className: 'checkout-address'

  constructor: (@order) ->
    super(arguments)
    @listenTo @order, 'change', @render

    @load()

  render: =>
    if @order.isLoaded()
      @$el.html(@template(current_address: @order.toJSON().order.ship_address))
    $('[placeholder]').placeholder()
    @

  getAddress: ->
    address = {}
    for input in @$('form input[name]')
      address[$(input).attr('name')] = $(input).val()
    address

  # private

  load: =>
    @order.load().done(@render)
