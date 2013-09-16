class GameComponent
  constructor: (game) ->
    @setGame(game)
  setGame: (game) ->
    @game = game
  getGame: () ->
    game

class StrategyInterface extends GameComponent
  begin: () ->

class HumanStrategy extends StrategyInterface
  begin: () ->
    #leave empty, as human will actually click via the mouse
    super

class AIStrategy extends StrategyInterface
  begin: () ->
    #ai strategy will need to
    #A) pick an element
    #B) trigger a jQuery click on it
    super

class RandomAIStrategy extends StrategyInterface
  begin: () ->
    possibilities = []
    for row in @getGame().board.getGrid()
      for el in row
        if not el.getOwner()
          possibilities.push el
    console.log(possibilities)
    possibilities[Math.floor(Math.random() * possibilities.length)].getDOMel().trigger('click')
    super

class Player extends GameComponent
  constructor: (symbol, strategy) ->
    @setSymbol(symbol)
    strategy.setGame(@getGame)
    @setStrategy(strategy)
    super @getGame
  setSymbol: (symbol) ->
    @symbol = symbol
  getSymbol: () ->
    @symbol
  setStrategy: (strategy) ->
    @strategy = strategy
  getStrategy: () ->
    @strategy
  go: () ->
    @getStrategy().begin()

class BoardElement extends GameComponent
  setDOMel: (el) ->
    @el = $(el)
    @el.click =>
      @handle_element_clicked()
  getDOMel: () ->
    @el
  setOwner: (owner) ->
    @owner = owner
  getOwner: () ->
    @owner
  handle_element_clicked: () ->
    if @getOwner()
      console.log("Already owned by #{@getOwner().getSymbol()}")
      return false
    @setOwner(@getGame().getCurrentPlayer())
    @getDOMel().attr("data-owner", @getGame().getCurrentPlayer().getSymbol())
    @getGame().schedule()

class Board extends GameComponent
  getGrid: () ->
    @grid
  grid: [[new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)]]

class TicTacToe
  constructor: (playerA, playerB) ->
    playerA.setGame(this)
    playerB.setGame(this)
    @players[0] = playerA
    @players[1] = playerB
    @setCurrentPlayer(@players[0])
    #TODO: strategize this out
    for row_num, row of @board.getGrid()
      for el_num, el of row
        el.setDOMel("[data-row=#{row_num}] [data-col=#{el_num}]")
  players: new Array(2)
  board: new Board(this)
  getCurrentPlayer: () ->
    @current_player
  setCurrentPlayer: (player) ->
    @current_player = player
  schedule: () ->
    if @getCurrentPlayer() == @players[0]
      @setCurrentPlayer(@players[1])
    else
      @setCurrentPlayer(@players[0])
    @getCurrentPlayer().go()

@game = new TicTacToe(new Player("x", new HumanStrategy()), new Player("o", new RandomAIStrategy()))
