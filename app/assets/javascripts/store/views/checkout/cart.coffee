class Store.views.Checkout.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/cart']
  className: 'checkout-cart'

  events:
    'click .buttons [data-role=register]': 'showRegistration'

  constructor: (@checkout) ->
    super(arguments)
    @loginForm = new Store.views.Account.LoginForm
    @cartView  = new Store.views.Cart(@checkout)
    @currentUser = Store.currentUser
    @currentUser.on 'change', @render

  render: =>
    @$el.html(@template(currentUser: @currentUser.toJSON()))
    @attachButtons()
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @assignSubview(@cartView, '[data-subview=cart]')
    @

  # private

  proceed: =>
    if @checkout.get('state') == 'cart'
      @checkout.advanceStep().done(@triggerProceed)
    else
      @triggerProceed()

  triggerProceed: =>
    @trigger('proceed')

  showRegistration: (e) =>
    e?.preventDefault()
    Store.messageBus.trigger('register')
