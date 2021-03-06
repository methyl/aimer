class Store.views.StaticPage extends Backbone.View
  className: 'static-page'

  constructor: (name) ->
    @template = HandlebarsTemplates["store/templates/static_page/#{name}"]

  render: ->
    @$el.html(@template())
    setTimeout =>
      @trigger('change:height', @$el.outerHeight())
    , 0
