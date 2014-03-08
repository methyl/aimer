class Store.views.Checkout.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/cart']
  className: 'checkout-cart'

  events:
    'click .without-account button': 'handleWithoutLoginClick'
    'click [data-role=next-cart]': 'proceed'

  constructor: (@checkout) ->
    super(arguments)
    @loginForm = new Store.views.Account.LoginForm
    @user = Store.currentUser
    @listenTo @user, 'change', @render
    @listenTo @loginForm, 'login', @proceed

  render: =>
    @$el.html(@template(currentUser: @user.toJSON()))
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  getEmail: =>
    @$('form.without-account [name=email]').val()

  proceed: =>
    if @checkout.get('state') == 'cart'
      @checkout.advanceStep().then =>
        @trigger('proceed')
    else
      @trigger('proceed')

  # private

  handleWithoutLoginClick: (e) ->
    e.preventDefault()
    @trigger('click:process-without-account')
