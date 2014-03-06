class Store.views.Account.LoginPopup extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_popup']
  className: 'account-login-popup'

  events:
    'click [data-role=submit]': 'submitLogin'
    'click .overlay': 'close'
    'click .popup': (e) -> e.stopPropagation()

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
