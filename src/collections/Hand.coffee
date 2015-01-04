class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    card = @deck.pop()
    @add(card)
    if @busted() then @trigger 'bust', @
    card

  stand: ->
    @trigger 'stand', @

  go: ->
    @first().flip()
    @hit() while @minScore() < 17
    @stand() if not @busted()

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    [@minScore(), @minScore() + 10 * @hasAce()]

  bestScore: ->
    scores = @scores()
    if scores[1] <= 21 then scores[1] else scores[0]

  busted: ->
    @minScore() > 21

  hasBlackjack: ->
    @scores()[0] is 21 or @scores()[1] is 21