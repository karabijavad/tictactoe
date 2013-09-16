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
    console.log("-----\nbeginning AIStrategy")
    console.log("Current Player:")
    console.log(@getGame().getCurrentPlayer())
    @decision = null
    for row_num, row of @getGame().board.getGrid()
      console.log("scanning row " + row_num)
      console.log("Element 0: ")
      console.log(row[0].getOwner())
      console.log("Element 1: ")
      console.log(row[1].getOwner())
      console.log("Element 2: ")
      console.log(row[2].getOwner())
      if (row[0].getOwner() == row[1].getOwner() == @getGame().getCurrentPlayer())
        if (row[2].getOwner() == undefined)
          @decision = row[2]
          console.log("Matched strat 1")
      if (row[0].getOwner() == row[2].getOwner() == @getGame().getCurrentPlayer())
        if (row[1].getOwner() == undefined)
          @decision = row[1]
          console.log("Matched strat 2")
      if (row[1].getOwner() == row[2].getOwner() == @getGame().getCurrentPlayer())
        if (row[0].getOwner() == undefined)
          @decision = row[0]
          console.log("Matched strat 3")
    if not @decision
      console.log("no decision made, going with random fall back")
      possibilities = []
      for row in @getGame().board.getGrid()
        for el in row
          if not el.getOwner()
            possibilities.push el
      @decision = possibilities[Math.floor(Math.random() * possibilities.length)]
    @decision.getDOMel().trigger('click')
    super

class RandomAIStrategy extends StrategyInterface
  begin: () ->
    possibilities = []
    for row in @getGame().board.getGrid()
      for el in row
        if not el.getOwner()
          possibilities.push el
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
    return false if not @getGame().active
    if @getOwner()
      console.log("Already owned by #{@getOwner().getSymbol()}")
      return false
    @setOwner(@getGame().getCurrentPlayer())
    @getDOMel().html(@getGame().getCurrentPlayer().getSymbol())
    @getGame().schedule()

class Board extends GameComponent
  getGrid: () ->
    @grid
  grid: [[new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)]]
  check_for_win: () ->
    if (@grid[0][0].getOwner() == @grid[1][0].getOwner() == @grid[2][0].getOwner())
      return @grid[0][0].getOwner()
    if (@grid[0][1].getOwner() == @grid[1][1].getOwner() == @grid[2][1].getOwner())
      return @grid[0][1].getOwner()
    if (@grid[0][2].getOwner() == @grid[1][2].getOwner() == @grid[2][2].getOwner())
      return @grid[0][2].getOwner()
    if (@grid[0][0].getOwner() == @grid[1][1].getOwner() == @grid[2][2].getOwner())
      return @grid[0][0].getOwner()
    if (@grid[0][2].getOwner() == @grid[1][1].getOwner() == @grid[2][0].getOwner())
      return @grid[0][2].getOwner()
    for row in @grid
      if row[0].getOwner() == row[1].getOwner() == row[2].getOwner()
        return row[0].getOwner()

class TicTacToe
  constructor: (playerA, playerB) ->
    @active = true
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
    if(@board.check_for_win())
      console.log("Winner found! #{@getCurrentPlayer().getSymbol()}")
      @active = false
      return false
    if @getCurrentPlayer() == @players[0]
      @setCurrentPlayer(@players[1])
    else
      @setCurrentPlayer(@players[0])
    @getCurrentPlayer().go()

@game = new TicTacToe(new Player("x", new HumanStrategy()), new Player("o", new AIStrategy()))
