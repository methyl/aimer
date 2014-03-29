class Store.views.Spinner extends Backbone.View
  defaults:
    className: ''
    size: 24
    steps: 12
    interval: 60

  constructor: (options) ->
    @options = _.extend({}, @defaults, options)
    @options.className = "spinner #{@options.className}"
    super(@options)

  setElement: (el) ->
    super(el)
    @setInitialStyle()
    @

  remove: ->
    @stop()
    super()

  show: (el) ->
    @$el.appendTo(el)
    @step = 0
    @el.style.display = 'inline-block'
    @start()
    @

  hide: ->
    @el.style.display = 'none'
    @stop()

  # private

  start: ->
    @nextStep() unless @timeout?

  stop: ->
    window.clearTimeout(@timeout) if @timeout?
    @timeout = null

  nextStep: =>
    @el.style.backgroundPosition = "-#{@step * @options.size}px 0"
    @step = (@step + 1) % @options.steps
    @timeout = window.setTimeout(@nextStep, @options.interval)

  setInitialStyle: ->
    @$el.css
      width: @options.size
      height: @options.size
      backgroundSize: "#{@options.size * @options.steps}px #{@options.size}px"
