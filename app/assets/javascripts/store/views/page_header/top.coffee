class Store.views.PageHeader.Top extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header/top']
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
    @listenTo @order, 'change', @render

  render: =>
    @$el.html(@template(
      user: @user.toJSON()
      order: new Store.presenters.Order(@order).toJSON() if @order.isLoaded()
    ))
    @

  # private

  login: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('login')

  logout: (e) ->
    e.preventDefault()
    @session.logout()
