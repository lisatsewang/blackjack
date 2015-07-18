class window.CardView extends Backbone.View
  className: 'card'

  template: _.template '<img>'#'<%= rankName %> of <%= suitName %>'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @model.attributes
    @$el.addClass 'covered' unless @model.get 'revealed'
    fileName = "./img/cards/#{@model.get('rankName')}-#{@model.get('suitName')}.png"
    @$el.find('img').attr('src', fileName.toLowerCase())
    console.log(@model)

