class Store.views.Checkout extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout']
  attributes:
    'class': 'checkout'

  events:
    'click .next-step': 'advanceStep'

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: (@order) ->
    super(arguments)
    @checkout = new Store.models.Checkout({}, order: @order)
    @products = new Store.views.Products(@order)
    @load()

  render: =>
    if @checkout.isLoaded()
      @$el.html(@template())
      @showCurrentView()
    @

  load: ->
    @checkout.load().done(@render)

  # private

  updateCurrentStep: ->
    @currentStep = @checkout.get('state')

  getCurrentStep: ->
    @currentStep ?= @checkout.get('state')

  showCurrentView: =>
    @updateCurrentStep()
    switch @getCurrentStep()
      when 'cart'     then @showCart()
      when 'address'  then @showAddress()
      when 'delivery' then @showDelivery()
      when 'payment'  then @showPayment()
      when 'complete' then @showComplete()
    @assignSubview(@[@getCurrentStep()], '[data-subview=current-view]')

  advanceStep: (e) =>
    e.preventDefault?()
    switch @getCurrentStep()
      when 'address'
        @processAddress().then(@showCurrentView)
      when 'delivery'
        @processShipment().then(@showCurrentView)
      when 'payment'
        @processPayment().then(@showCurrentView)
      when 'complete'
        window.location.hash = ''
        window.location.reload()
      else @showCurrentView()

  showProducts: ->
    @products ?= new Store.views.Products

  showCart: ->
    @cart ?= new Store.views.Cart(@order)
    @listenTo @cart, 'click:process-without-account', @processEmail

  showAddress: ->
    @address ?= new Store.views.Address(@order)

  showDelivery: ->
    @delivery ?= new Store.views.Shipping(@order)
    @listenTo @delivery, 'change:shipment', @processShipment

  showPayment: ->
    @payment ?= new Store.views.Payment(@order)

  showComplete: ->
    @complete ?= new Store.views.Complete(@order)
    @order.clearLocalStorage()

  processAddress: ->
    @checkout.updateAddress(@address.getAddress())

  processShipment: ->
    @checkout.updateShipment(@delivery.getShipment())

  processEmail: (email) ->
    @checkout.updateEmail(email).then(@showCurrentView)

  processPayment: ->
    @checkout.updatePayment(@payment.getPayment())
