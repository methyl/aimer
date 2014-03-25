class Store.views.PageHeader.Top extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header/top']
  cartTemplate: HandlebarsTemplates['store/templates/page_header/cart']
  className: 'page-header-top'

  events:
    'click [data-role=login]': 'login'
    'click [data-role=register]': 'register'
    'click [data-role=logout]': 'logout'

  BOTTOM_SCROLL_MARGIN = 100

  constructor: ->
    super
    @user = Store.currentUser
    @session = new Store.models.UserSession
    @listenTo @user, 'add remove reset change', @render
    @order = @user.getOrder()
    @listenTo @order, 'change', @renderCart

    $(window).on 'scroll', @applyFixed

  render: =>
    @$el.attr('style', 'position: relative')
    @$el.html(@template(
      user: @user.toJSON()
    ))
    @renderCart() if @isLoaded()
    @applyFixed()
    @

  # private

  renderCart: ->
    @$('li.cart').html(@cartTemplate(
      order: new Store.presenters.Order(@order).toJSON()
    ))

  remove: ->
    super
    $(window).off 'scroll', @applyFixed

  applyFixed: =>
    return if window.innerWidth < 950

    # fix for elements not rendering after changing content
    @$el.css(position: 'static').css(position: 'fixed')

    scrollTop = $(window).scrollTop()
    if scrollTop > 3
      @$('.header').addClass('fixed')
    else
      @$('.header').removeClass('fixed')
    if scrollTop > 15
      @$el.addClass('fixed')
    else
      @$el.removeClass('fixed')
    if scrollTop > 38
      @$('.submenu').addClass('fixed')
    else
      @$('.submenu').removeClass('fixed')

  login: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('login')

  logout: (e) ->
    e.preventDefault()
    @session.logout()

  register: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('register')

  isLoaded: ->
    @order.get('line_items')?
