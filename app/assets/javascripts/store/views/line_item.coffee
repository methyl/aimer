class Store.views.LineItem extends Backbone.View
  tagName: 'li'
  template: HandlebarsTemplates['store/templates/line_item']
  attributes: ->
    'class': 'line-item'
    'data-id': @lineItem.get('id')

  constructor: (@lineItem) ->
    super(arguments)
    @listenTo @lineItem, 'change', @render

  render: =>
    @$el.html(@template(@lineItem.toJSON()))
    @initializeSlider()
    @

  initializeSlider: ->
    @$('.slider').slider
      min: 0
      max: 20
      value: @lineItem.get('quantity')
      slide: _.debounce (e, ui) =>
        @lineItem.save({ quantity: ui.value }, wait: true)
      , 500
