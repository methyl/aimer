class Store.views.Checkout extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout']
  attributes:
    'class': 'checkout'

  events:
    'click [data-step]': 'showStep'

  steps: ['cart', 'address', 'delivery', 'payment', 'complete']

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: (@order) ->
    super(arguments)
    @checkout = new Store.models.Checkout({}, order: @order)
    @cartPartial = new Store.views.Cart(order: @order)
    @user = Store.currentUser
    @createViews()
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
    if @checkout.get('state') == 'complete'
      step == 'complete'
    else
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

  getNextStep: ->
    @steps[@steps.indexOf(@getCurrentStep()) + 1]

  showCurrentView: =>
    if @getCurrentStep() == 'complete'
      @resetOrder()
    else
      @updateCurrentStep()
      @updateAvailableSteps()
      @assignSubview(@[@getCurrentStep()], '[data-subview=current-view]')

  createViews: ->
    @cart     = new Store.views.Checkout.Cart(@checkout)
    @address  = new Store.views.Checkout.Address(@checkout)
    @delivery = new Store.views.Checkout.Shipping(@checkout)
    @payment  = new Store.views.Checkout.Payment(@checkout)
    @listenTo @cart, 'proceed',     => @setCurrentStep('address')
    @listenTo @address, 'proceed',  => @setCurrentStep('delivery')
    @listenTo @delivery, 'proceed', => @setCurrentStep('payment')
    @listenTo @payment, 'proceed',  => @setCurrentStep('complete')

  resetOrder: ->
    @user.getOrder().clearLocalStorage()
    window.location.pathname = 'complete'
