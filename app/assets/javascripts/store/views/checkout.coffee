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
    @load()

  render: =>
    if @checkout.isLoaded()
      @$el.html(@template())
      @showCurrentView(false)
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
    @showCurrentView()

  getCurrentStep: ->
    @currentStep

  getNextStep: ->
    @steps[@steps.indexOf(@getCurrentStep()) + 1]

  showCurrentView: (animate = true) =>
    @updateCurrentStep()
    @updateAvailableSteps()
    if animate and @previousStep != @currentStep
      @assignSubview(@[@getCurrentStep()], '[data-subview=next-view]')
      @transitionViews()
    else
      @assignSubview(@[@getCurrentStep()], '[data-subview=current-view]')

  transitionViews: ->
    @isAnimated = true
    nextView = @$('.next-view')
    currentView = @$('.current-view')
    nextView.show()
    if @steps.indexOf(@previousStep) > @steps.indexOf(@currentStep)
      nextView.css(left: -(nextView.width() + nextView.offset().left))
      currentView.animate(left: window.innerWidth)
    else
      nextView.css(left: window.innerWidth)
      currentView.animate(left: -(currentView.width() + currentView.offset().left))
    nextView.animate(left: '0')
    setTimeout =>
      @$('.current-view').empty().css(left: 0)
      @$('.next-view > div').attr('data-subview', 'current-view').appendTo(@$('.current-view'))
      @$('.next-view').html('<div data-subview="next-view"></div>').hide()
      @isAnimated = false
    , 500

  createViews: ->
    @cart     = new Store.views.Checkout.Cart(@checkout)
    @address  = new Store.views.Checkout.Address(@checkout)
    @delivery = new Store.views.Checkout.Shipping(@checkout)
    @payment  = new Store.views.Checkout.Payment(@checkout)
    @listenTo @cart, 'proceed',     => @setCurrentStep('address')
    @listenTo @address, 'proceed',  => @setCurrentStep('delivery')
    @listenTo @delivery, 'proceed', => @setCurrentStep('payment')
    @listenTo @payment, 'proceed',  =>
      @complete = new Store.views.Checkout.Complete(_.clone(@order))
      @order.reload()
      @setCurrentStep('complete')
