class Store.views.Home extends Backbone.View
  template: HandlebarsTemplates['store/templates/home']
  events:
    'click [data-id] a': 'addToCart'

  constructor: ->
    super(arguments)
    @order = Store.currentOrder
    @products = new Store.models.Products
    @load()

  render: =>
    @$el.html(@template(items: @lineItems?.toJSON(), products: @products.toJSON().products))
    @

  load: ->
    $.when(@order.fetch(), @products.fetch()).then =>
      @lineItems = @order.get('line_items')
      @listenTo @lineItems, 'add remove change', @render
      @render()

  addToCart: (e) ->
    el = $(e.currentTarget).parent()
    quantity = el.find('[name=quantity]').val()
    item = {variant_id: parseInt(el.data('id')), quantity}
    @order.addLineItem(item)
