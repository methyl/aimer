class Store.views.Checkout extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout']
  attributes:
    'class': 'checkout'

  events:
    'click [data-step]': 'showStep'

  steps: ['cart', 'address', 'delivery', 'payment', 'complete']

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: ->
    super(arguments)
    @user = Store.currentUser
    @checkout = new Store.models.Checkout
    @viewSwitcher = new Store.views.ViewSwitcher
    @order = @user.getOrder()
    @load()

  render: =>
    if @checkout.isLoaded()
      @$el.html(@template())
      @assignSubview @viewSwitcher, '[data-subview=view-switcher]'
      @showCurrentView()
      @trigger('change:height', @$el.outerHeight())
    @

  load: ->
    @checkout.load().done =>
      @currentStep = @checkout.get('state')
      @createViews()
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
    return if @isAnimated
    step = $(e.currentTarget).data('step')
    @setCurrentStep(step)

  setCurrentStep: (step) ->
    return unless @isStepAvailable(step)
    @previousStep = @currentStep
    @currentStep = step
    @showCurrentView(animate: true)

  getCurrentStep: ->
    @currentStep

  getCurrentView: ->
    @[@getCurrentStep()]

  getNextStep: ->
    @steps[@steps.indexOf(@getCurrentStep()) + 1]

  showCurrentView: (options = {}) =>
    @updateCurrentStep()
    @updateAvailableSteps()
    _.extend(options, { direction: @getDirection() })
    @viewSwitcher.setView(@getCurrentView(), options)

  getDirection: ->
    if @steps.indexOf(@previousStep) > @steps.indexOf(@currentStep) then 'left' else 'right'

  createViews: ->
    @cart     = new Store.views.Checkout.Cart(@checkout)
    @address  = new Store.views.Checkout.Address(@checkout)
    @delivery = new Store.views.Checkout.Shipping(@checkout)
    @payment  = new Store.views.Checkout.Payment(@checkout)
    @listenTo @cart, 'proceed',     => @setCurrentStep('address')
    @listenTo @address, 'proceed',  => @setCurrentStep('delivery')
    @listenTo @delivery, 'proceed', => @setCurrentStep('payment')
    @listenTo @payment, 'proceed',  =>
      @complete = new Store.views.Checkout.Complete(_.clone(@order), @order.get('number'))
      @order.reload()
      @setCurrentStep('complete')
