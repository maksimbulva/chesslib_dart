import 'package:chesslib_dart/core/engine/fen/fen_decoder.dart';
import 'package:chesslib_dart/core/engine/move/move_generator.dart';
import 'package:chesslib_dart/core/engine/position/position.dart';
import 'package:test/test.dart';

void main() {
  test('moveCountFromInitialPosition', () {
    final position = FenDecoder().decode(
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
    expect(_countMoves(position, 1), 20);
    expect(_countMoves(position, 2), 400);
  });
}

int _countMoves(Position position, int depth) {
  if (depth < 1) {
    return 0;
  }

  final moves = MoveGenerator().generateMoves(position);
  if (depth > 1) {
    var result = 0;
    for (final move in moves) {
      result += _countMoves(position.playMove(move), depth - 1);
    }
    return result;
  } else {
    return moves.length;
  }
}
