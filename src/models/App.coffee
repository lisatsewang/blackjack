# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    @get('playerHand').on('bust', @gameOver , @)
    @get('dealerHand').on('bust', @gameOver, @)

    @get('playerHand').on('stand', @handleStand, @)

  decideLoser: ->

    difference = @get('playerHand').bestScorePrivate() - @get('dealerHand').bestScorePrivate()

    loser = if difference is 0 then null
    else if difference > 0 then @get('dealerHand')
    else @get('playerHand')

    return loser

  handleStand: ->
    while @get('dealerHand').bestScorePrivate() < 17
      console.log(@get('dealerHand').bestScorePrivate())
      @get('dealerHand').hit()
    @gameOver(@decideLoser()) if @get('dealerHand').bestScorePrivate() <= 21

  gameOver: (loser) ->
    @get('dealerHand').at(0).flip()
    @trigger('gameOver', loser)
