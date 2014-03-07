class Store.views.Checkout.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/cart']
  className: 'checkout-cart'

  events:
    'click .without-account button': 'handleWithoutLoginClick'

  constructor: ->
    super(arguments)
    @loginForm = new Store.views.Account.LoginForm
    @user = Store.currentUser
    @listenTo @user, 'change', @render

  render: =>
    @$el.html(@template(currentUser: @user.toJSON()))
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  getEmail: =>
    @$('form.without-account [name=email]').val()

  # private

  handleWithoutLoginClick: (e) ->
    e.preventDefault()
    @trigger('click:process-without-account')
