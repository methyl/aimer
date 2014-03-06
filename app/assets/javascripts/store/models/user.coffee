class Store.models.User extends Backbone.Model
  getOrder: ->
    @order ?= new Store.models.Order
    @order.set('number', @get('last_incomplete_order_number')) if @get('last_incomplete_order_number')
    @order

class Store.models.CurrentUser extends Store.models.User
  url: "/api/current_user"

class Store.models.UserSession
  constructor: ->
    @user = Store.currentUser

  login: (email, password) ->
    $.post('/login.json', { spree_user: { email, password } }).done (data) =>
      @updateAuthenticityToken(data.authenticity_token)
      @user.fetch()

  logout: ->
    $.get('/logout.json').done =>
      @user.getOrder().clearLocalStorage()
      window.location.reload()

  updateAuthenticityToken: (token) =>
    $('meta[name=csrf-token]').attr('content', token)
