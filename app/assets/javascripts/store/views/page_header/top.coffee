class Store.views.PageHeader.Top extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header/top']
  cartTemplate: HandlebarsTemplates['store/templates/page_header/cart']
  className: 'page-header-top'

  events:
    'click [data-role=login]': 'login'
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
    scrollTop = $(window).scrollTop()
    if scrollTop > 10
      @$('.content').addClass('fixed')
    else
      @$('.content').removeClass('fixed')
    if scrollTop > 21
      @$('.content').addClass('dark')
      @$('.separator').addClass('fixed')
    else
      @$('.content').removeClass('dark')
      @$('.separator').removeClass('fixed')

  login: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('login')

  logout: (e) ->
    e.preventDefault()
    @session.logout()

  isLoaded: ->
    @order.get('line_items')?
