class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  events:
    'click .without-account button': 'handleWithoutLoginClick'

  constructor: (@order) ->
    super(arguments)
    @listenTo @order, 'change', @render

    @load()

  render: =>
    @$el.html(@template(order: @order.toJSON(), lineItems: @order.getLineItems()?.toJSON()))
    @

  # private

  load: =>
    @order.load().done(@render)

  handleWithoutLoginClick: (e) ->
    e.preventDefault()
    email = @$('form.without-account [name=email]').val()
    @trigger('click:process-without-account', email)
