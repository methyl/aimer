class Store.views.Account.LoginForm extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_form']
  className: 'account-login-form'

  events:
    'click [data-role=submit]': 'submitLogin'

  constructor: ->
    super()
    @session = new Store.models.UserSession

  render: =>
    @$el.html(@template())
    @

  # private

  submitLogin: (e) ->
    e.preventDefault()
    @session.login(@$('[name=email]').val(), @$('[name=password]').val()).then =>
      @trigger('login')
    , => @trigger('fail')
