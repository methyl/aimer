class Store.views.Account.LoginPopup extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_popup']
  className: 'account-login-popup'

  events:
    'click .overlay': 'remove'
    'click .popup': (e) -> e.stopPropagation()

  constructor: ->
    super()
    @loginForm = new Store.views.Account.LoginForm
    @listenTo @loginForm, 'log-in', @remove

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  show: ->
    @render().$el.appendTo($('body'))
