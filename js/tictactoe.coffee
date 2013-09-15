class Player
  constructor: (symbol) ->
    @setSymbol(symbol)
  setSymbol: (symbol) ->
    @symbol = symbol
  getSymbol: () ->
    @symbol

class BoardElement
  setDOMel: (el) ->
    @el = el
  getDOMel: () ->
    @el
  setOwner: (owner) ->
    @owner = owner
  getOwner: () ->
    @owner

class Board
  getGrid: () ->
    grid
  grid: [[new BoardElement, new BoardElement, new BoardElement],
        [new BoardElement, new BoardElement, new BoardElement],
        [new BoardElement, new BoardElement, new BoardElement]]

class TicTacToe
  constructor: (playerA, playerB) ->
    @players[0] = playerA
    @players[1] = playerB
  players: new Array(2)
  board: new Board

@game = new TicTacToe(new Player("x"), new Player("o"))
