class Store.views.Cart extends Backbone.View
  template: HandlebarsTemplates['store/templates/cart']
  className: 'cart'

  events:
    'click [data-role=increase-quantity]': 'onIncreaseQuantityClick'
    'click [data-role=decrease-quantity]': 'onDecreaseQuantityClick'
    'click [data-role=remove]': 'onRemoveClick'

  constructor: (@checkout) ->
    super(arguments)
    @order = @checkout.getOrder()

    @listenTo @order, 'add reset change', @render

    @setQuantity = _.debounce(@setQuantity, 500)

  render: =>
    @$el.html(@template(order: new Store.presenters.Order(@order).toJSON()))
    @hideRemoveButton() if @order.getLineItems().length == 1
    @hideActionButtons() unless @actionButtonsEnabled()
    @

  showSpinner: ->
    @spinner ?= new Store.views.Spinner
    @spinner.show(@$('.total'))

  # private

  actionButtonsEnabled: ->
    @order.get('current-step') == 'cart' || @order.get('current-step') == 'address'

  hideRemoveButton: ->
    @$('[data-role=remove]').hide()

  hideActionButtons: ->
    @$('button.action').css(visibility: 'hidden')

  onRemoveClick: (e) ->
    e.preventDefault()
    id = parseInt $(e.currentTarget).data('id'), 10
    @showSpinner()
    @order.removeLineItem(@order.getLineItemForProductId(id))

  onIncreaseQuantityClick: (e) ->
    e.preventDefault()
    id = parseInt $(e.currentTarget).data('id'), 10
    quantity = parseInt(@$("tr[data-id=#{id}] [data-role=quantity]").html(), 10) + 1
    @$("tr[data-id=#{id}] [data-role=quantity]").html(quantity)
    @setQuantity(id, quantity)

  onDecreaseQuantityClick: (e) ->
    e.preventDefault()
    id = parseInt $(e.currentTarget).data('id'), 10
    quantity = parseInt(@$("tr[data-id=#{id}] [data-role=quantity]").html(), 10) - 1
    if quantity > 0
      @$("tr[data-id=#{id}] [data-role=quantity]").html(quantity)
      @setQuantity(id, quantity)

  setQuantity: (id, quantity) =>
    @showSpinner()
    @hideActionButtons()
    lineItem = @order.getLineItemForProductId(id)
    @order.addLineItem({ variant_id: id, quantity: quantity })
