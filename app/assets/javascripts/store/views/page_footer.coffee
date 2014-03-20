class Store.views.PageFooter extends Backbone.View
  template: HandlebarsTemplates['store/templates/page_footer']
  className: 'page-footer'

  events:
    'submit #contact form': 'onFormSubmit'

  constructor: ->
    super

  render: ->
    @$el.html(@template())
    @

  onFormSubmit: (e) ->
    e.preventDefault()
    contact = new Store.models.Contact
      email: @$('[name=email]').val()
      subject: @$('[name=subject]').val()
      message: @$('[name=message]').val()
    contact.save().then =>
      alert('Wiadomość została odebrana!')
      @clearForm()

  clearForm: ->
    @$('[name=email]').val('')
    @$('[name=subject]').val('')
    @$('[name=message]').val('')
