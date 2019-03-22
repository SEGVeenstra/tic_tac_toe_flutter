enum Player {Player1, Player2}

class Game {
  final _history = List<BoardState>();

  BoardState get currentBoardState => _history.last;
  Player get playerTurn => _history.length % 2 == 1 ? Player.Player1 : Player.Player2;
  Player get winner => currentBoardState.winner;
  
  Game(){
    _history.add(BoardState.empty());
  }

  move(Player player, int fieldNumber){
    if(winner != null)
      throw InvalidMoveException(TicTacToeError.gameOver);

    if(currentBoardState.lastMoveMadeBy == player || currentBoardState.lastMoveMadeBy == null && player == Player.Player2)
      throw InvalidMoveException(TicTacToeError.wrongPlayer);

    if(fieldNumber < 0 || fieldNumber > 8)
      throw InvalidMoveException(TicTacToeError.fieldOutOfBounds);

    if(currentBoardState.fields[fieldNumber] != null)
      throw InvalidMoveException(TicTacToeError.occupiedField);

    var newFields = List.of(currentBoardState.fields);
    newFields[fieldNumber] = player;

    _history.add(BoardState(newFields, player));
    return currentBoardState;
  }

}

class BoardState {
  final List<Player> fields;
  final Player lastMoveMadeBy;

  static final _emptyFields = [null,null,null,null,null,null,null,null,null];

  BoardState(this.fields, this.lastMoveMadeBy);

  factory BoardState.empty() => BoardState(_emptyFields, null);

  Player get winner => _getWinner();

  @override
  bool operator ==(other) {
    if(!(other is BoardState)) return false;

    var otherBoardState = other as BoardState;

    for (var i = 0; i < fields.length; i++ ) {
      if(otherBoardState.fields[i] != fields[i]) return false;
    }

    if(otherBoardState.lastMoveMadeBy != lastMoveMadeBy)
      return false;

    return true;
  }

  Player _getWinner() {
    // Diagonal 1
    if(fields[0] == fields[4] && fields[0] == fields[8])
      return fields[0];
    // Diagonal 2
    if(fields[2] == fields[4] && fields[2] == fields[6])
      return fields[2];
    // Row 1
    if(fields[0] == fields[1] && fields[0] == fields[2])
      return fields[0];
    // Row 2
    if(fields[3] == fields[4] && fields[3] == fields[5])
      return fields[3];
    // Row 3
    if(fields[6] == fields[7] && fields[6] == fields[8])
      return fields[6];
    // Column 1
    if(fields[0] == fields[3] && fields[0] == fields[6])
      return fields[0];
    // Column 2
    if(fields[1] == fields[4] && fields[1] == fields[7])
      return fields[1];
    // Column 3
    if(fields[2] == fields[5] && fields[2] == fields[8])
      return fields[2];
    return null;
  }
}

enum TicTacToeError {wrongPlayer, occupiedField, fieldOutOfBounds, gameOver}

class InvalidMoveException implements Exception {
  final TicTacToeError err;
  
  InvalidMoveException([this.err]);

  @override
  String toString() => err.toString() ?? 'InvalidMoveException';
}