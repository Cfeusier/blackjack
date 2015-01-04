class window.AppView extends Backbone.View
  className: 'app'

  bjTemplate: _.template '
    <h1>Blackjack! You win!</h1>
    <h3>Collect your money</h3>
    <a href="index.html" class="start-link">Play Another Hand</a>
  '

  template: _.template '
    <h2 class="winner"></h2>
    <button class="hit-button button">Hit</button> <button class="stand-button button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()

  initialize: ->
    @model.on 'all', @updateGameDisplay, @

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  updateGameDisplay: (e) ->
    if @endEvents(e) then @disableBtns() and @playAgain()
    switch e
      when 'blackjack-player'
        @blackjack()
      when 'win-player'
        @updateWinner("PLAYER")
      when 'win-dealer'
        @updateWinner("DEALER")
      when 'push'
        @displayPush()

  disableBtns: -> @$('.button').css 'display', 'none'

  endEvents: (e) -> e is 'win-player' or e is 'win-dealer' or e is 'push'

  updateWinner: (winner) -> @$('.winner').text("The winner is the #{winner}")

  displayPush: -> @$('.winner').text("PUSH - we are all winners")

  blackjack: -> $('body').html @bjTemplate()

  playAgain: ->
    @$el.prepend('<a href="index.html" class="start-link">Play Another Hand</a><br /><br />')
