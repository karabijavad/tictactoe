class GameComponent
  constructor: (game) ->
    @setGame(game)
  setGame: (game) ->
    @game = game
  getGame: () ->
    game

class Player extends GameComponent
  constructor: (symbol) ->
    @setSymbol(symbol)
  setSymbol: (symbol) ->
    @symbol = symbol
  getSymbol: () ->
    @symbol

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
    return false if @getOwner()
    @setOwner(@getGame().getCurrentPlayer())
    @getGame().schedule()

class Board extends GameComponent
  getGrid: () ->
    @grid
  grid: [[new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)],
        [new BoardElement(@game), new BoardElement(@game), new BoardElement(@game)]]

class TicTacToe
  constructor: (playerA, playerB) ->
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

@game = new TicTacToe(new Player("x"), new Player("o"))
