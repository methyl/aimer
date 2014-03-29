_.extend Backbone.View.prototype,
  assignSubview: (subview, element) ->
    element = @$(element).eq(0)
    return unless element.length > 0
    attrs       = _.extend({}, _.result(subview, 'attributes'))
    attrs.id    = _.result(subview, 'id')        if subview.id
    attrs.class = _.result(subview, 'className') if subview.className
    subview.setElement(element.attr(attrs)).render()

  removeSubview: (subview) ->
    subview.setElement(document.createElement('div'))
    subview.remove()

  detach: ->
    @$el.detach()

  attachButtons: ->
    for el in @$('[data-action]')
      $(el).data('view')?.remove()
      actionFn = _.bind @[_.str.camelize $(el).data('action')], @
      view = new Store.views.Button({ el, actionFn })
      $(el).data('view', view)

syncer = new class
  sync: (method, model, options) =>
    options.url ?= _.result(model, 'url')
    Backbone.sync(method, model, options)

for klass in [Backbone.Collection, Backbone.Model]
  _.extend klass.prototype,
    sync: syncer.sync

    load: ->
      @loadingRequest ?= do =>
        @trigger('loading')
        @fetch().done => @trigger('loaded')

    isLoaded: ->
      @loadingRequest? && @loadingRequest.state() == 'resolved'
