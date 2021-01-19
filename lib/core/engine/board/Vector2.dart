import 'package:chesslib_dart/core/engine/board/board.dart';
import 'package:chesslib_dart/core/engine/board/board_square.dart';

class Vector2 {
  final int deltaRow;
  final int deltaColumn;

  Vector2(this.deltaRow, this.deltaColumn);

  Vector2.fromBoardSquares(BoardSquare origin, BoardSquare dest)
    : this(dest.row - origin.row, dest.column - origin.column);

  BoardSquare? operator +(BoardSquare boardSquare) {
    final resultRow = boardSquare.row + deltaRow;
    if (resultRow < 0 || resultRow >= Board.ROW_COUNT) {
      return null;
    }
    final resultColumn = boardSquare.column + deltaColumn;
    if (resultColumn < Board.COLUMN_A || resultColumn > Board.COLUMN_H) {
      return null;
    }
    return BoardSquare(resultRow, resultColumn);
  }
}
