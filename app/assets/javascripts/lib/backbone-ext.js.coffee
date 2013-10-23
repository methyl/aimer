syncer = new class
  sync: (method, model, options) =>
    options.url ?= _.result(model, 'url')
    queryString = options.queryString || _.result(model, 'queryString')
    options.url += queryString if queryString
    Backbone.sync(method, model, options)

for klass in [Backbone.Collection, Backbone.Model]
  _.extend klass.prototype,
    sync: syncer.sync
