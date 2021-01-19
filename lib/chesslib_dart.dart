import 'core/engine/fen/fen_decoder.dart';
import 'core/engine/move/move_generator.dart';
import 'core/engine/position/position.dart';

int calculate() {
  final position = FenDecoder().decode(
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
  return _countMoves(position, 5);
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
