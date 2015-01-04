class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()

  start: ->
    deck = @get 'deck'
    $.when(
      @set 'playerHand', deck.dealPlayer()
      @set 'dealerHand', deck.dealDealer()
      @get('playerHand').on 'all', @playerEvents, @
      @get('dealerHand').on 'all', @dealerEvents, @
    ).done => if @get('playerHand').hasBlackjack() then @trigger 'blackjack-player', @

  playerEvents: (e, hand) ->
    switch e
      when 'bust' then @trigger 'win-dealer'
      when 'stand' then @get('dealerHand').go()

  dealerEvents: (e, hand) ->
    switch e
      when 'bust' then @trigger 'win-player'
      when 'stand' then @checkWinner()

  checkWinner: ->
    player = @get('playerHand').bestScore()
    dealer = @get('dealerHand').bestScore()
    if player > dealer then @trigger 'win-player'
    else if player < dealer then @trigger 'win-dealer'
    else @trigger 'push'
