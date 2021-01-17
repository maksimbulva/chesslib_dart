import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/piece.dart';

class Move {
  final BoardSquare fromSquare;
  final BoardSquare toSquare;
  final Piece? promoteTo;
  final bool isEnPassantCapture;
  final bool isCastle;

  Move(this.fromSquare, this.toSquare, this.promoteTo, this.isEnPassantCapture,
      this.isCastle);

  Move.byCoordinates(BoardSquare fromSquare, BoardSquare toSquare)
    : this(fromSquare, toSquare, null, false, false);

  Move.promotion(
      BoardSquare fromSquare,
      BoardSquare toSquare,
      Piece promoteTo
  ) : this(fromSquare, toSquare, promoteTo, false, false);

  Move.enPassantCapture(
      BoardSquare fromSquare,
      BoardSquare toSquare
  ) : this(fromSquare, toSquare, null, true, false);

  @override
  String toString() {
    return '$fromSquare$toSquare';
  }
}
