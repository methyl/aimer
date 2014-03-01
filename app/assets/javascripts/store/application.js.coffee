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

class Store.Router extends Backbone.Router
  routes:
    '': 'products'
    'checkout': 'checkout'

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
    $('#content').html(view.render().$el)

class Store.Application
  constructor: ->
    @order = new Store.models.Order
    @router = new Store.Router(@)

  prepare: ->
    if @order.isNew()
      @order.save().then(@setupAjax)
    else
      @setupAjax()
      new $.Deferred().resolve()

  start: ->
    @router.start()
    @enableRoutedLinks()

  setupAjax: =>
    $.ajaxSetup
      headers:
        'X-Spree-Order-Token': @order.get('token')

  enableRoutedLinks: ->
    $('body').on 'click', 'a[data-route]', (e) =>
      e.preventDefault()
      @router.navigate($(e.currentTarget).attr('href'), trigger: true)
$ ->
  app = new Store.Application
  app.prepare().then(=> app.order.fetch()).done =>
    app.start()
