#= require ../popup

class Store.views.Account.LoginPopup extends Store.views.Popup
  template: HandlebarsTemplates['store/templates/account/login_popup']
  className: 'popup account-login-popup'

  constructor: ->
    super()
    @loginForm = new Store.views.Account.LoginForm
    @listenTo @loginForm, 'login', @remove
    @listenTo @loginForm, 'fail', @shake

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  # private

  shake: =>
    @$('.modal').effect('shake')
