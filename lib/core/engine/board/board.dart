import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/colored_piece.dart';
import 'package:chesslib_dart/core/engine/move/move.dart';
import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';

class Board {
  static const int BOARD_SQUARE_COUNT = 64;
  static const int ROW_COUNT = 8;

  static const int COLUMN_A = 0;
  static const int COLUMN_H = 7;

  final List<ColoredPiece?> _cells;

  Board(this._cells) {
    assert(_cells.length == BOARD_SQUARE_COUNT);
  }

  bool isAtCoordinatesEmpty(int row, int column) {
    return _cells[_encodeBoardCoordinates(row, column)] == null;
  }

  bool isEmpty(BoardSquare boardSquare) {
    return isAtCoordinatesEmpty(boardSquare.row, boardSquare.column);
  }

  bool isOccupiedByPlayer(BoardSquare boardSquare, Player player) {
    final cellValue = _cells[_encodeBoardSquare(boardSquare)];
    return cellValue?.player == player;
  }

  ColoredPiece? getPieceAtCoordinates(int row, int column) {
    return _cells[_encodeBoardCoordinates(row, column)];
  }

  ColoredPiece? getPieceAt(BoardSquare boardSquare) {
    return _cells[_encodeBoardSquare(boardSquare)];
  }

  // List<ColoredPiece> enumerateSquares() {
  //   return _cells;
  // }

  BoardSquare? getKingBoardSquare(Player player) {
    // TODO: optimize me
    for (var i = 0; i < _cells.length; ++i) {
      final currentCell = _cells[i];
      if (currentCell != null &&
          currentCell.piece == Piece.King &&
          currentCell.player == player) {
        return _indexToBoardSquare(i);
      }
    }
    return null;
  }

  Board playMove(Move move, Player player) {
    assert(!isEmpty(move.fromSquare));
    final newCells = List<ColoredPiece?>.from(_cells);
    final movingPiece = getPieceAt(move.fromSquare)!;
    newCells[_encodeBoardSquare(move.fromSquare)] = null;

    if (move.promoteTo == null) {
      newCells[_encodeBoardSquare(move.toSquare)] = movingPiece;
    } else {
      newCells[_encodeBoardSquare(move.toSquare)] =
          ColoredPiece(player, move.promoteTo!);
    }

    if (move.isEnPassantCapture) {
      final capturedSquareIndex =
          _encodeBoardCoordinates(move.fromSquare.row, move.toSquare.column);

      newCells[capturedSquareIndex] = null;
    }

    if (move.isCastle) {
      final rookColumn =
          move.fromSquare.column < move.toSquare.column ? COLUMN_A : COLUMN_H;
      final rookFromSquare = BoardSquare(move.fromSquare.row, rookColumn);
      assert(getPieceAt(rookFromSquare)?.piece == Piece.Rook &&
          getPieceAt(rookFromSquare)?.player == player);

      final rookToSquare = BoardSquare(move.fromSquare.row,
          (move.fromSquare.column + move.toSquare.column) >> 1);

      final rookFromSquareIndex = _encodeBoardSquare(rookFromSquare);
      final movingRook = newCells[rookFromSquareIndex];
      newCells[rookFromSquareIndex] = null;
      newCells[_encodeBoardSquare(rookToSquare)] = movingRook;
    }

    return Board(newCells);
  }

  int _encodeBoardCoordinates(int row, int column) {
    return row * 8 + column;
  }

  int _encodeBoardSquare(BoardSquare boardSquare) {
    return _encodeBoardCoordinates(boardSquare.row, boardSquare.column);
  }

  BoardSquare _indexToBoardSquare(int index) {
    return BoardSquare(index >> 3, index & 7);
  }
}
