#= require ../popup

class Store.views.Account.RegistrationPopup extends Store.views.Popup
  template: HandlebarsTemplates['store/templates/account/registration_popup']
  className: 'popup account-registration-popup'

  events:
    'submit form': 'onFormSubmit'
    'keyup input': 'onInputKeyup'
    'click .overlay': 'hide'
    'click .modal': (e) -> e.stopPropagation()

  VALIDATIONS = {
    'email':    (val) -> val.match /.+@.+\..+/
    'password': (val) -> val.match /.{6,}/
    'password_confirmation': (val) -> val.match(/.{6,}/) and val == @$('[name=password]').val()
  }

  constructor: ->
    super()

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  show: =>
    @promise = new $.Deferred()
    super()
    @promise


  # private

  onInputKeyup: (e) ->
    $(e.currentTarget).removeClass('invalid')

  onFormSubmit: (e) ->
    e.preventDefault()
    if @validate()
      user = new Store.models.User
      user.save({ user: {
        email: @$('[name=email]').val()
        password: @$('[name=password]').val()
        password_confirmation: @$('[name=password_confirmation]').val()
      }}).done =>
        Store.currentUser.fetch().then(@hide)
        @promise.resolve()
      .fail(@shake)

  shake: =>
    @$('.modal').effect('shake')

  validate: ->
    result = true
    for name, validate of VALIDATIONS
      field = @$("form [name=#{name}]")
      unless _.bind(validate, @, field.val())()
        result = false
        field.addClass('invalid')
    result
