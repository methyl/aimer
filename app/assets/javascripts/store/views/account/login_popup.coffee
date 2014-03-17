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
    @listenTo @loginForm, 'fail', @shake

  render: =>
    @$el.html(@template())
    @assignSubview(@loginForm, '[data-subview=login-form]')
    @

  show: ->
    @render().$el.appendTo($('body'))
    @showPopup(animate: true)
    @setBodyProperties()
    @$('input').first().focus()

  remove: =>
    @hidePopup(animate: true).then =>
      super
      @unsetBodyProperties()

  # private

  shake: =>
    @$('.popup').effect('shake')

  setBodyProperties: ->
    $('body').css(overflowY: 'scroll', height: window.innerHeight)

  unsetBodyProperties: ->
    $('body').css(overflow: 'auto', height: 'auto')

  hidePopup: (options = {}) ->
    if options.animate
      @showPopup()
    @movePopup(-@$('.popup').outerHeight(), options)

  showPopup: (options = {}) ->
    if options.animate
      @hidePopup()
    @movePopup(200, options)

  movePopup: (top, options = {} ) ->
    if options.animate
      @$('.popup').animate({ top }, 500, 'easeOutCubic').promise()
    else
      @$('.popup').css { top }
