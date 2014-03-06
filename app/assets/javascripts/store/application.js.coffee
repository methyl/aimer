#= require jquery
#= require jquery_ujs
#= require lib/common
#= require lib/backbone

#= require_tree ./templates

#= require_self
#= require_tree .

window.Store = {}
window.Store.models = {}
window.Store.presenters = {}
window.Store.views = {}
window.Store.application = {}

class Store.Router extends Backbone.Router
  routes:
    '': 'products'
    'checkout': 'checkout'
    'login': 'login'

  constructor: (@app) ->
    super(arguments)

  start: ->
    Backbone.history.start()

  products: ->
    @app.order.load().done =>
      @products = new Store.views.Products(@app.order)
      @showView(@products)

  checkout: ->
    @app.order.load().done =>
      if @app.order.get('step') == 'products' || @app.order.get('line_items').length == 0
        @navigate('/', trigger: true)
      else
        @checkout = new Store.views.Checkout(@app.order)
        @showView(@checkout)

  showView: (view) ->
    @app.showView(view)

class Store.MessageBus
  constructor: (@app) ->
    $.extend(@, Backbone.Events)
    @on 'login', @showLoginPopup

  showLoginPopup: =>
    popup = new Store.views.Account.LoginPopup
    popup.login().done => @app.order.fetch()

class Store.Application
  constructor: ->
    @router = new Store.Router(@)
    @user = Store.currentUser = new Store.models.CurrentUser
    Store.messageBus  = new Store.MessageBus(@)
    @applicationView = new Store.views.Application

  prepare: ->
    @user.load().then =>
      @order = @user.getOrder()
      if @order.isNew()
        @order.save().then(@setupAjax)
      else
        @setupAjax()
        new $.Deferred().resolve()

  start: ->
    @router.start()
    @enableRoutedLinks()
    @applicationView.render().$el.appendTo('body')

  showView: (view) ->
    @applicationView.showView(view)

  setupAjax: =>
    console.log @order
    $.ajaxSetup
      headers:
        'X-Spree-Order-Token': @order.get('token')

  enableRoutedLinks: ->
    $('body').on 'click', 'a[data-route]', (e) =>
      e.preventDefault()
      @router.navigate($(e.currentTarget).attr('href'), trigger: true)

$ ->
  Store.application = new Store.Application
  Store.application.prepare().then(=> Store.application.order.fetch()).done =>
    Store.application.start()
