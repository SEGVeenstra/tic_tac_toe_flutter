import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tic_tac_toe/tic_tac_toe/tic_tac_toe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tic Tac Toe"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _gameBlock.reset();
              },
            )
          ],
        ),
        body: StreamBuilder<Game>(
            stream: _gameBlock.game,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  child: Center(
                    child: Text("No Data"),
                  ),
                );
              else
                return TicTacToeWidget(snapshot.data);
            }));
  }
}

class TicTacToeWidget extends StatelessWidget {
  final Game _game;

  TicTacToeWidget(this._game);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: EdgeInsets.all(16.0),
              color: _game.gameState == GameState.busy
                  ? Colors.black12
                  : Colors.amber,
              child: Center(child: Text(_getInfoTextFromGame(_game)))),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(3, (index) =>
                  Expanded(child: Row(
                    children: [
                      Expanded(
                          child: FieldWidget(_game, index*3+0)),
                      Expanded(
                          child: FieldWidget(_game, index*3+1)),
                      Expanded(
                          child: FieldWidget(_game, index*3+2)),
                    ],
                  ),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInfoTextFromGame(Game game) {
    switch(game.gameState){
      case GameState.draw:
        return "Draw";
      case GameState.busy:
        return "It's Player${game.playerTurn == Player.Player1 ? '1' : '2'}'s turn!";
      case GameState.player1Won:
        return "Player 1 Won!";
      case GameState.player2Won:
        return "Player 2 Won!";
    }
  }
}

class FieldWidget extends StatelessWidget {
  final TextStyle _style = TextStyle(fontSize: 100);

  final Game _game;
  final int _index;

  FieldWidget(this._game, this._index);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blueGrey[50]],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _gameBlock.doMove(_game.playerTurn, _index);
          },
          child: Center(
              child: Text(
            _getFieldMark(_game.currentBoardState.fields[_index]),
            style: _style,
          )),
        ),
      ),
    );
  }

  String _getFieldMark(Player player) {
    if (player == Player.Player1) return "X";
    if (player == Player.Player2) return "O";
    return "";
  }
}

class TicTacToeBloc {
  Game _game;

  final _gameFetcher = BehaviorSubject<Game>();

  Observable<Game> get game => _gameFetcher.stream;

  TicTacToeBloc() {
    reset();
  }

  doMove(Player player, int field) {
    try {
      _game.move(player, field);
      _gameFetcher.add(_game);
    } catch (e) {
      print(e);
    }
  }

  reset() {
    _game = Game();
    _gameFetcher.add(_game);
  }

  close() {
    _gameFetcher.close();
  }
}

final _gameBlock = TicTacToeBloc();
