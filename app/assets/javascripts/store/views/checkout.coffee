class Store.views.Checkout extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout']
  attributes:
    'class': 'checkout'

  events:
    'click .next-step': 'advanceStep'
    'click [data-step]': 'showStep'

  steps: ['cart', 'address', 'delivery', 'payment', 'complete']

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: (@order) ->
    super(arguments)
    @checkout = new Store.models.Checkout({}, order: @order)
    @cartPartial = new Store.views.Cart(order: @order)
    @currentStep = @steps[0]
    @load()

  render: =>
    if @checkout.isLoaded()
      @$el.html(@template())
      @showCurrentView()
      @assignSubview(@cartPartial, '[data-subview=cart]')
    @

  load: ->
    @checkout.load().done(@render)

  # private

  isStepAvailable: (step) ->
    @steps.indexOf(step) <= @steps.indexOf(@checkout.get('state'))

  updateCurrentStep: ->
    @$("[data-step]").removeClass('current')
    @$("[data-step=#{@getCurrentStep()}]").addClass('current')

  updateAvailableSteps: ->
    @$("[data-step]").removeClass('available')
    for step in @steps
      @$("[data-step=#{step}]").addClass('available') if @isStepAvailable(step)

  showStep: (e) ->
    e.preventDefault()
    step = $(e.currentTarget).data('step')
    @setCurrentStep(step)

  setCurrentStep: (step) ->
    return unless @isStepAvailable(step)
    @currentStep = step
    @showCurrentView()

  getCurrentStep: ->
    @currentStep
    # @step || @checkout.get('state')

  getNextStep: ->
    @steps[@steps.indexOf(@getCurrentStep()) + 1]

  showCurrentView: =>
    switch @getCurrentStep()
      when 'cart'     then @showCart()
      when 'address'  then @showAddress()
      when 'delivery' then @showDelivery()
      when 'payment'  then @showPayment()
      when 'complete' then @showComplete()
    @updateCurrentStep()
    @updateAvailableSteps()
    @assignSubview(@[@getCurrentStep()], '[data-subview=current-view]')

  advanceStep: (e) =>
    e?.preventDefault?()
    promise = switch @getCurrentStep()
      when 'cart'
        @processEmail()
      when 'address'
        @processAddress()
      when 'delivery'
        @processShipment()
      when 'payment'
        @processPayment()
      when 'complete'
        window.location.hash = ''
        window.location.reload()
        dfr = new $.Deferred; dfr.resolve(); dfr
      else dfr = new $.Deferred; dfr.resolve(); dfr
    promise.then =>
      @setCurrentStep(@getNextStep())

  showCart: ->
    @cart ?= new Store.views.Checkout.Cart(@order)
    @listenTo @cart, 'click:process-without-account', @advanceStep

  showAddress: ->
    @address ?= new Store.views.Checkout.Address(@order)

  showDelivery: ->
    @delivery ?= new Store.views.Checkout.Shipping(@order)
    @listenTo @delivery, 'change:shipment', @processShipment

  showPayment: ->
    @payment ?= new Store.views.Checkout.Payment(@order)

  showComplete: ->
    @complete ?= new Store.views.Checkout.Complete(@order)
    @order.clearLocalStorage()

  processAddress: ->
    @checkout.updateAddress(@address.getAddress())

  processShipment: ->
    @checkout.updateShipment(@delivery.getShipment())

  processEmail: ->
    @checkout.updateEmail(@cart.getEmail())

  processPayment: ->
    @checkout.updatePayment(@payment.getPayment())
