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
    _gaq.push(['_addTrans',
      @order.get('number'),
      'Kulki',
      @order.get('total'),
      @order.get('included_tax_total'),
      @order.get('ship_total'),
      @order.get('ship_address').city,
      '',
      'Polska'
    ])
    @order.get('line_items').each (lineItem) =>
      _gaq.push(['_addItem',
        @order.get('number'),
        lineItem.get('variant').sku,
        lineItem.get('variant').name,
        lineItem.get('variant').weight,
        lineItem.get('price'),
        lineItem.get('quantity')
      ]);
    _gaq.push(['_trackTrans']);
