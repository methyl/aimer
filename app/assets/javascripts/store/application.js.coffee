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
    '': 'home'
    'checkout': 'checkout'
    'login': 'login'
    'contact': 'contact'
    'about': 'about'

  constructor: (@app) ->
    super(arguments)

  start: ->
    Backbone.history.start(pushState: true)

  home: ->
    @products = new Store.views.Products
    @showView(@products)

  checkout: ->
    order = Store.currentUser.getOrder()
    if order.get('step') == 'products' || order.get('line_items').length == 0
      @navigate('/', trigger: true)
    else
      @checkout = new Store.views.Checkout
      @showView(@checkout)

  about: ->
    @home()
    setTimeout =>
      $('body, html').scrollTop($('#about').offset().top)
    , 0

  contact: ->
    @home()
    setTimeout =>
      $('body, html').scrollTop($('#contact').offset().top)
    , 0

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
        @order.fetch().then(true, @order.reload)

  start: ->
    @router.start()
    @enableRoutedLinks()
    @enableAnchorLinks()
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

  enableAnchorLinks: ->
    $('body').on 'click', 'a[data-anchor]', (e) =>
      e.preventDefault()
      el = $($(e.currentTarget).attr('href'))
      el.addClass('highlight')
      @router.navigate(el.attr('id'))
      $('html, body').animate
        scrollTop: el.offset().top - $('.page-header-top').height()
      500
      setTimeout ->
        el.removeClass('highlight')
      , 2000

$ ->
  Store.application = new Store.Application
  Store.application.prepare().done =>
    Store.application.start()
