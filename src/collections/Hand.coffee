class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    @trigger('bust', @) if @minScorePrivate() > 21

  stand: ->
    @trigger('stand') unless @isDealer

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  minScorePrivate: -> @reduce (score, card) ->
    score + card.get 'value'
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  scoresPrivate: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScorePrivate(), @minScorePrivate() + 10 * @hasAce()]

  bestScore: -> 
    scores = if @at(0).revealed then @scoresPrivate() else @scores()
    return if scores[1] > 21 then scores[0] else scores[1]

  bestScorePrivate: -> 
    scores = @scoresPrivate()
    return if scores[1] > 21 then scores[0] else scores[1]  

  identity: ->
    if @isDealer then "Dealer" else "Player"

  oppositeIdentity: ->
    if not @isDealer then "Dealer" else "Player"