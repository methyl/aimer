class Store.views.Account.LoginForm extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_form']
  className: 'account-login-form'

  events:
    'click [data-role=submit]': 'submitLogin'
    'click [data-role=register]': 'showRegistration'

  constructor: ->
    super()
    @session = new Store.models.UserSession

  render: =>
    @$el.html(@template())
    @

  # private

  showRegistration: (e) ->
    e.preventDefault()
    @trigger('show-registration')

  submitLogin: (e) ->
    e.preventDefault()
    @$('button').prop('disabled', true)
    @session.login(@$('[name=email]').val(), @$('[name=password]').val())
    .always =>
      @$('button').prop('disabled', false)
    .then =>
      @trigger('login')
    , =>
      @trigger('fail')
      @$('button').html('Zaloguj się')
