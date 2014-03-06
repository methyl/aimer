class Store.models.User extends Backbone.Model

  constructor: (attrs, options = {}) ->
    super(attrs, options)
    @on 'change:last_incomplete_order_number', @getOrder

  getOrder: =>
    @order ?= new Store.models.Order
    if @get('last_incomplete_order_number')
      @order.set('number', @get('last_incomplete_order_number'))
      @order.set('email',  @get('email'))
      @order.save()
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
      @user.getOrder().fetch()

  logout: ->
    $.get('/logout.json').done =>
      @user.getOrder().clearLocalStorage()
      window.location.reload()

  updateAuthenticityToken: (token) =>
    $('meta[name=csrf-token]').attr('content', token)
