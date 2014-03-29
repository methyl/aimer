class Store.views.Checkout.Address extends Backbone.View
  template: HandlebarsTemplates['store/templates/checkout/address']
  className: 'checkout-address'

  events:
    'submit form': (e) -> e.preventDefault(); @$('[data-action=proceed]').data('view').fire()
    'keyup input': 'removeError'

  VALIDATIONS = {
    'firstname': (val) -> val.match /[A-Za-z]+/
    'lastname':  (val) -> val.match /[A-Za-z]+/
    'address1':  (val) -> val.match /[A-Za-z0-9]+ [0-9]*/
    'zipcode':   (val) -> val.match /[0-9]{2}-[0-9]{3}/
    'city':      (val) -> val.match /[A-Za-z]+/
    'phone':     (val) -> val.match /^[0-9]{3}[- ]?[0-9]{3}[- ]?[0-9]{3}$/
    'email':     (val) -> val.match /.+@.+\..+/
  }

  constructor: (@checkout) ->
    super(arguments)
    @user = Store.currentUser
    @order = @checkout.getOrder()
    @cart = new Store.views.Cart(@checkout)
    @user.on 'change:address', @render

  render: =>
    @$el.html(@template(
      email: @order.toJSON().email || @user.toJSON().email,
      current_address: @order.toJSON().ship_address || @user.toJSON().address
    ))
    @attachButtons()
    @assignSubview(@cart, '[data-subview=cart]')
    $('[placeholder]').placeholder()
    @

  # private

  proceed: =>
    if @validate()
      @checkout.updateAddressAndEmail(@getAddress(), @getEmail()).then(@triggerProceed)

  triggerProceed: =>
    @trigger('proceed')

  validate: ->
    result = true
    for name, validate of VALIDATIONS
      field = @$("form [name=#{name}]")
      unless validate(field.val())
        result = false
        field.addClass('invalid')
    result

  removeError: (e) ->
    $(e.currentTarget).removeClass('invalid')

  load: =>
    @order.load().done(@render)

  getAddress: ->
    address = {}
    for input in @$('form [data-role=address] input[name]')
      address[$(input).attr('name')] = $(input).val()
    address

  getEmail: ->
    @$('form input[name=email]').val()
