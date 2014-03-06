class Store.views.Header extends Backbone.View
  template: HandlebarsTemplates['store/templates/header']
  className: 'page-header'

  events:
    'click [data-role=login]': 'login'
    'click [data-role=logout]': 'logout'

  constructor: ->
    super
    @user = Store.currentUser
    @session = new Store.models.UserSession
    @listenTo @user, 'add remove reset change', @render

  render: =>
    @$el.html(@template(
      user: @user.toJSON()
    ))
    @

  login: (e) ->
    e.preventDefault()
    Store.messageBus.trigger('login')

  logout: (e) ->
    e.preventDefault()
    @session.logout()
