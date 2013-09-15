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
  board: new Board

@game = new TicTacToe