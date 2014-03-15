class Store.views.Checkout.Complete extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/complete']
  className: 'checkout-complete'

  constructor: (@order, @number) ->
    super
    @presenter = new Store.presenters.Order(@order)

  render: ->
    json = @presenter.toJSON()
    json.number = @number
    @$el.html(@template(json))
    @
