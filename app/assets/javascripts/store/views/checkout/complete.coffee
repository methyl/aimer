class Store.views.Checkout.Complete extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/complete']
  className: 'checkout-complete'

  constructor: (@order, @number) ->
    super
    @presenter = new Store.presenters.Order(@order)
    @triggerAnalyticsEvent()

  render: ->
    json = @presenter.toJSON()
    json.number = @number
    @$el.html(@template(json))
    @

  triggerAnalyticsEvent: ->
    _gaq.push([
      '_trackEvent',
      'order', # category
      'complete', # action
      @order.get('source_track'), # label
      Math.floor(parseFloat(@order.get('total'))) # value
    ])
