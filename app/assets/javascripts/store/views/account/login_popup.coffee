class Store.views.Account.LoginPopup extends Backbone.View
  template: HandlebarsTemplates['store/templates/account/login_popup']
  className: 'account-login-popup'

  events:
    'click .overlay': 'remove'
    'click .popup': (e) -> e.stopPropagation()

  constructor: ->
    super()
    @loginForm = new Store.views.Account.LoginForm
    @listenTo @loginForm, 'login', @remove

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  show: ->
    @render().$el.appendTo($('body'))
    @$('.popup').css(top: -@$('.popup').height())
    @$('.popup').animate({ top: 200 }, 500, 'easeOutCubic')
    $('body').css(overflow: 'hidden', height: window.innerHeight)
    @$('input').first().focus()

  remove: =>
    super
    $('body').css(overflow: 'auto', height: 'auto')
