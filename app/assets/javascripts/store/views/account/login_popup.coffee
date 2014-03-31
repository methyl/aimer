#= require ../popup

class Store.views.Account.LoginPopup extends Store.views.Popup
  template: HandlebarsTemplates['store/templates/account/login_popup']
  className: 'popup account-login-popup'

  constructor: ->
    super()
    @loginForm = new Store.views.Account.LoginForm
    @listenTo @loginForm, 'login', @hide
    @listenTo @loginForm, 'show-registration', @showRegistration
    @listenTo @loginForm, 'fail', @shake

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  # private

  showRegistration: ->
    @hide().done -> Store.messageBus.trigger('register', => @trigger('login'))

  shake: =>
    @$('.modal').effect('shake')
