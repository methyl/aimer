class Store.views.Account.LoginForm extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_form']
  className: 'account-login-form'

  events:
    'click [data-role=register]': 'showRegistration'

  constructor: ->
    super()
    @session = new Store.models.UserSession

  render: =>
    @$el.html(@template())
    @attachButtons()
    @

  # private

  showRegistration: (e) ->
    e.preventDefault()
    @trigger('show-registration')

  submitLogin: ->
    @session.login(@$('[name=email]').val(), @$('[name=password]').val()).then(@triggerLogin, @triggerFail)

  triggerLogin: =>
    @trigger('login')

  triggerFail: =>
    @trigger('fail')
