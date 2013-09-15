class Player
  constructor: (symbol) ->
    @setSymbol(symbol)
  setSymbol: (symbol) ->
    @symbol = symbol
  getSymbol: () ->
    @symbol

class BoardElement
  setDOMel: (el) ->
    @el = $(el)
  getDOMel: () ->
    @el
  setOwner: (owner) ->
    @owner = owner
  getOwner: () ->
    @owner

class Board
  getGrid: () ->
    @grid
  grid: [[new BoardElement, new BoardElement, new BoardElement],
        [new BoardElement, new BoardElement, new BoardElement],
        [new BoardElement, new BoardElement, new BoardElement]]

class TicTacToe
  constructor: (playerA, playerB) ->
    @players[0] = playerA
    @players[1] = playerB
    #TODO: strategize this out
    for row_num, row of @board.getGrid()
      for el_num, el of row
        el.setDOMel("[data-row=#{row_num}] [data-col=#{el_num}]")
  players: new Array(2)
  board: new Board

@game = new TicTacToe(new Player("x"), new Player("o"))
