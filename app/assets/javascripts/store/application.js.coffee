#= require jquery
#= require jquery_ujs
#= require lib/common
#= require lib/backbone

#= require_tree ./templates

#= require_self
#= require_tree .

window.Store = {}
window.Store.models = {}
window.Store.presenters = {}
window.Store.views = {}

class Store.Application
  constructor: ->

  run: ->
    Store.currentOrder = new Store.models.Order

$ ->
  app = new Store.Application
  app.run()
  home = new Store.views.Home

  # quick fix, to be removed
  if Store.currentOrder.isNew()
    Store.currentOrder.save().then =>
      $('body').append(home.render().$el)
  else
    $('body').append(home.render().$el)
