class Store.models.User extends Backbone.Model
  url: '/spree/api/users'

  constructor: (attrs, options = {}) ->
    super(attrs, options)
    @on 'change:last_incomplete_order_number', @getOrder

  save: (key, val, options) ->
    super(key, val, options).then ->
      Store.currentUser.fetch()

  getOrder: =>
    @order ?= new Store.models.Order
    if @get('last_incomplete_order_number') and @order.get('line_items')?.length == 0
      @order.set('number', @get('last_incomplete_order_number'))
      @order.set('email',  @get('email'))
      @order.save()
    @order

class Store.models.CurrentUser extends Store.models.User
  url: "/spree/api/current_user"

class Store.models.UserSession
  constructor: ->
    @user = Store.currentUser

  login: (email, password) ->
    $.post('/spree/login.json', { spree_user: { email, password } }).then (data) =>
      @updateAuthenticityToken(data.authenticity_token)
      @user.fetch()
    .then => @user.getOrder().fetch()

  logout: ->
    $.get('/spree/logout.json').done =>
      @user.getOrder().clearCookies()
      window.location.reload()

  updateAuthenticityToken: (token) =>
    $('meta[name=csrf-token]').attr('content', token)
