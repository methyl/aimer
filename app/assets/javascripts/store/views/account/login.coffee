class Store.views.Account.Login extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login']
  className: 'account-login'

  events:
    'click [data-role=submit]': 'submitLogin'

  constructor: ->
    super()
    @loginPromise = new $.Deferred
    @session = new Store.models.UserSession

  render: =>
    @$el.html(@template())
    @

  login: ->
    @render().$el.appendTo($('body'))
    @loginPromise

  close: ->
    @loginPromise.reject()
    @remove()

  # private

  submitLogin: (e) ->
    e.preventDefault()
    @session.login(@$('[name=email]').val(), @$('[name=password]').val()).then =>
      @loginPromise.resolve()
      @remove()
