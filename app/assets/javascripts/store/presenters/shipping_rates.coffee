class Store.presenters.ShippingRates
  constructor: (rates) ->
    @rates = _.clone(rates)

  toJSON: ->
    for rate in @rates
      rate.description = @getDescription(rate)
      rate.formatted_cost = @formatCost(rate)
    @rates = _(@rates).reject(@expensive)
    @rates = _(@rates).sortBy('cost')
    @rates = _(@rates).sortBy('name')

  expensive: (rate) =>
    parseFloat(rate.cost) >= 20

  getDescription: (rate) ->
    if _(@rates).where(name: rate.name).length > 1
      if rate.cash_on_delivery
        "za pobraniem"
      else
        "płatność z góry"

  formatCost: (rate) ->
    fixed = parseFloat(rate.cost).toFixed(2).replace('.', ',')
    [ whole, rest ] = fixed.split(',')
    if rest == '00'
      whole + ' pln'
    else
      whole + '.' + rest + ' pln'

