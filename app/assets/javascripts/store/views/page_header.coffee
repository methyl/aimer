class Store.views.PageHeader extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_header']
  className: 'page-header'

  events:
    'click [data-role=login]': 'login'
    'click [data-role=logout]': 'logout'

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
