class Store.views.Checkout extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout']
  attributes:
    'class': 'checkout'

  events:
    # 'click .next-step': 'advanceStep'
    'click [data-step]': 'showStep'

  steps: ['cart', 'address', 'delivery', 'payment', 'complete']

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: (@order) ->
    super(arguments)
    @checkout = new Store.models.Checkout({}, order: @order)
    @cartPartial = new Store.views.Cart(order: @order)
    @load()

  render: =>
    if @checkout.isLoaded()
      @$el.html(@template())
      @showCurrentView()
      @assignSubview(@cartPartial, '[data-subview=cart]')
    @

  load: ->
    @checkout.load().done =>
      @currentStep = @checkout.get('state')
      @render()

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

  advanceStep: =>
    @setCurrentStep(@getNextStep())

  showCart: ->
    @cart ?= new Store.views.Checkout.Cart(@checkout)
    @listenTo @cart, 'proceed', => @setCurrentStep('address')

  showAddress: ->
    @address ?= new Store.views.Checkout.Address(@checkout)
    @listenTo @address, 'proceed', => @setCurrentStep('delivery')

  showDelivery: ->
    @delivery ?= new Store.views.Checkout.Shipping(@checkout)
    @listenTo @delivery, 'proceed', => @setCurrentStep('payment')

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
