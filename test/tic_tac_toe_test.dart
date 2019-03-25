import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/tic_tac_toe/tic_tac_toe.dart';
import 'package:tic_tac_toe/main.dart';

void main() {
  test("Player1 should go first on a new game",(){

    var newGame1 = Game();
    expect(() => newGame1.move(Player.Player2, 0), throwsA((e) => isInvalidMoveExceptionWithError(e,TicTacToeError.wrongPlayer)));

    var newGame2 = Game();
    expect(() => newGame2.move(Player.Player1, 0), returnsNormally);
  });

  test("valid player but wrong field should throw error",(){

    var newGame1 = Game();
    expect(() => newGame1.move(Player.Player1, -1), throwsA((e) => isInvalidMoveExceptionWithError(e, TicTacToeError.fieldOutOfBounds)));

    var newGame2 = Game();
    expect(() => newGame2.move(Player.Player1, 9), throwsA((e) => isInvalidMoveExceptionWithError(e, TicTacToeError.fieldOutOfBounds)));

    var newGame3 = Game();
    newGame3.move(Player.Player1, 0);
    expect(() => newGame3.move(Player.Player2, 0), throwsA((e) => isInvalidMoveExceptionWithError(e, TicTacToeError.occupiedField)));
  });

  test("player has 3 in a row set winner", (){

    var newGame1 = Game();
    newGame1.move(Player.Player1, 0);
    expect(newGame1.gameState, GameState.busy);
    newGame1.move(Player.Player2, 1);
    expect(newGame1.gameState, GameState.busy);
    newGame1.move(Player.Player1, 4);
    expect(newGame1.gameState, GameState.busy);
    newGame1.move(Player.Player2, 2);
    expect(newGame1.gameState, GameState.busy);
    newGame1.move(Player.Player1, 8);
    expect(newGame1.gameState, GameState.player1Won);

    var newGame2 = Game();
    newGame2.move(Player.Player1, 1);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player2, 6);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player1, 5);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player2, 4);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player1, 2);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player2, 8);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player1, 3);
    expect(newGame2.gameState, GameState.busy);
    newGame2.move(Player.Player2, 7);
    expect(newGame2.gameState, GameState.player2Won);
  });

  test("valid move should update and return currentBoardState",(){

    var newGame1 = Game();

    var boardStateAfterTurn1 = newGame1.move(Player.Player1, 0);
    expect(boardStateAfterTurn1, equals(newGame1.currentBoardState));
    expect(newGame1.currentBoardState, equals(BoardState([Player.Player1,null,null,null,null,null,null,null,null], Player.Player1)));

    var boardStateAfterTurn2 = newGame1.move(Player.Player2, 8);
    expect(boardStateAfterTurn2, equals(newGame1.currentBoardState));
    expect(newGame1.currentBoardState, equals(BoardState([Player.Player1,null,null,null,null,null,null,null,Player.Player2], Player.Player2)));
  });

}

bool isInvalidMoveExceptionWithError(Exception exception, TicTacToeError error) {
  return exception is InvalidMoveException && (exception as InvalidMoveException).err == error;
}