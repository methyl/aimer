class Store.views.PageHeader extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header']
  className: 'page-header'

  events:
    'click [data-role=login]': 'login'
    'click [data-role=logout]': 'logout'
    'click [data-role=scroll-to-content]': 'scrollToContent'

  BOTTOM_SCROLL_MARGIN = 100

  constructor: ->
    super
    @user = Store.currentUser
    @session = new Store.models.UserSession
    @listenTo @user, 'add remove reset change', @render
    @order = @user.getOrder()
    @listenTo @order, 'change', @render

  render: =>
    @$el.html(@template(
      user: @user.toJSON()
      order: new Store.presenters.Order(@order).toJSON() if @order.isLoaded()
    ))
    @

  login: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('login')

  logout: (e) ->
    e.preventDefault()
    @session.logout()

  # private

  scrollToContent: (e) ->
    e.preventDefault()
    $('body').animate(scrollTop: @$el.height() - BOTTOM_SCROLL_MARGIN)
