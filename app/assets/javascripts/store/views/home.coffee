class Store.views.Home extends Backbone.View
  template: HandlebarsTemplates['store/templates/home']
  attributes:
    'class': 'home'

  ITEM_MARGIN = 10
  ANIMATION_DURATION = 500

  constructor: ->
    super(arguments)
    @order = Store.currentOrder
    @products = new Store.views.Products
    @cart = new Store.views.Cart

  render: =>
    @$el.html(@template())
    @assignSubview(@products, '[data-subview=products]')
    @assignSubview(@cart, '[data-subview=cart]')
    @

  load: ->
    $.when(@order.fetch(), @products.fetch()).then(@render)
