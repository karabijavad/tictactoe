class Player
  constructor: (symbol) ->
    @setSymbol(symbol)
  setSymbol: (symbol) ->
    @symbol = symbol
  getSymbol: () ->
    @symbol

class BoardElement
  setOwner: (owner) ->
    @owner = owner
  getOwner: () ->
    @owner

class Board
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
