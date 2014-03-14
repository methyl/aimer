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
    'complete': 'complete'
    'login': 'login'

  constructor: (@app) ->
    super(arguments)

  start: ->
    Backbone.history.start(pushState: true)

  products: ->
    @products = new Store.views.Products
    @showView(@products)

  checkout: ->
    order = Store.currentUser.getOrder()
    if order.get('step') == 'products' || order.get('line_items').length == 0
      @navigate('/', trigger: true)
    else
      @checkout = new Store.views.Checkout
      @showView(@checkout)

  complete: ->
    @showView new Store.views.Checkout.Complete

  showView: (view) ->
    @app.showView(view)

class Store.MessageBus
  constructor: (@app) ->
    $.extend(@, Backbone.Events)
    @on 'login', @showLoginPopup

  showLoginPopup: =>
    popup = new Store.views.Account.LoginPopup
    popup.show()

class Store.Application
  constructor: ->
    @router = new Store.Router(@)
    @user = Store.currentUser = new Store.models.CurrentUser
    Store.messageBus  = new Store.MessageBus(@)
    @applicationView = new Store.views.Application
    @setupAjax()

  prepare: ->
    @user.load().then =>
      @order = @user.getOrder()
      if @order.isNew()
        @order.save()
      else
        @order.fetch().fail =>
          @order.reload()

  start: ->
    @router.start()
    @enableRoutedLinks()
    @applicationView.render().$el.appendTo('body')

  showView: (view) ->
    @applicationView.showView(view)

  setupAjax: =>
    $.ajaxPrefilter (options) =>
      if options.url.match(/\/spree\/api\/(orders|checkouts)\/R\d+/)
        options.beforeSend = (xhr) =>
          xhr.setRequestHeader('X-Spree-Order-Token', @order.get('token'))

  enableRoutedLinks: ->
    $('body').on 'click', 'a[data-route]', (e) =>
      e.preventDefault()
      @router.navigate($(e.currentTarget).attr('href'), trigger: true)

$ ->
  Store.application = new Store.Application
  Store.application.prepare().done =>
    Store.application.start()
