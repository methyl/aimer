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
    'email':    {
      fn: (val) -> val.match /.+@.+\..+/
      message: 'Wprowadź poprawny email'
    }
    'password': {
      fn: (val) -> val.match /.{6,}/
      message: 'Hasło musi mieć co najmniej 6 znaków'
    }
    'password_confirmation': {
      fn: (val) -> val.match(/.{6,}/) and val == @$('[name=password]').val()
      message: 'Hasło i potwierdzenie muszą się zgadzać'
    }
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
    @clearErrors() unless e.keyCode == 13

  onFormSubmit: (e) ->
    e.preventDefault()
    if @validate()
      @$('button').prop('disabled', true)
      user = new Store.models.User
      user.save({ user: {
        email: @$('[name=email]').val()
        password: @$('[name=password]').val()
        password_confirmation: @$('[name=password_confirmation]').val()
      }}).done =>
        Store.currentUser.fetch().then(@hide)
        @promise.resolve()
      .fail(@onFail)
      .always => @$('button').prop('disabled', false)

  onFail: (data) =>
    @shake()
    @showErrors(data)

  clearErrors: =>
    @$('input').removeClass('invalid')
    @$('.error').remove()

  showErrors: (data) =>
    for field, errorMessages of data.responseJSON.errors
      @showError(@$("[name=#{field}]"), message) for message in errorMessages

  showError: (field, message) =>
    field.addClass('invalid').after("<div class='error'>#{message}</div>")

  shake: =>
    @$('.modal').effect('shake')

  validate: ->
    @clearErrors()
    result = true
    for name, validation of VALIDATIONS
      field = @$("form [name=#{name}]")
      unless _.bind(validation.fn, @, field.val())()
        result = false
        @showError(field, validation.message)
    result
