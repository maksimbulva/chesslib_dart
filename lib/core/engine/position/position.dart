import 'package:chesslib_dart/core/engine/board/board.dart';
import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/move/move.dart';
import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';
import 'package:chesslib_dart/core/engine/position/castling_availability.dart';

class Position {
  final Board board;
  final Player playerToMove;
  final CastlingAvailability whiteCastlingAvailability;
  final CastlingAvailability blackCastlingAvailability;
  final int? enPassantCaptureColumn;
  final int halfMoveClock;
  final int fullMoveNumber;

  bool get isCanCaptureEnPassant => enPassantCaptureColumn != null;

  bool? _isInCheckCached;

  Position(
      this.board,
      this.playerToMove,
      this.whiteCastlingAvailability,
      this.blackCastlingAvailability,
      this.enPassantCaptureColumn,
      this.halfMoveClock,
      this.fullMoveNumber);

  bool isInCheck() {
    if (_isInCheckCached != null) {
      return _isInCheckCached!;
    }

    // TODO: Implement me
    // MoveGenerator.isAttacksCell(
    //     this,
    //     playerToMove.otherPlayer(),
    //     board.kingCell(playerToMove)
    // )
    return false;
  }

  Position playMove(Move move) {
    final newEnPassantCaptureColumn =
        _isDoublePawnMove(move) ? move.fromSquare.column : null;

    var newWhiteCastlingAvailability = whiteCastlingAvailability;
    var newBlackCastlingAvailability = blackCastlingAvailability;
    if (playerToMove == Player.White) {
      newWhiteCastlingAvailability =
          _updateCastlingAvailability(whiteCastlingAvailability, move);
    } else {
      newBlackCastlingAvailability =
          _updateCastlingAvailability(blackCastlingAvailability, move);
    }

    return Position(
        board.playMove(move, playerToMove),
        getOtherPlayer(playerToMove),
        newWhiteCastlingAvailability,
        newBlackCastlingAvailability,
        newEnPassantCaptureColumn,
        _updateHalfmoveClock(halfMoveClock, move),
        fullMoveNumber + ((playerToMove == Player.Black) ? 1 : 0));
  }

  CastlingAvailability getCastlingAvailability(Player player) {
    return (player == Player.Black)
        ? blackCastlingAvailability
        : whiteCastlingAvailability;
  }

  CastlingAvailability _updateCastlingAvailability(
      CastlingAvailability currentValue, Move move) {
    final movedPiece = board.getPieceAt(move.fromSquare)?.piece;
    switch (movedPiece) {
      case Piece.King:
        {
          return CastlingAvailability.NONE;
        }
      case Piece.Rook:
        {
          final baseRow = (playerToMove == Player.Black) ? 7 : 0;
          final canCastleShort = currentValue.canCastleLong &&
              move.fromSquare.isEquals(BoardSquare(baseRow, Board.COLUMN_H));
          final canCastleLong = currentValue.canCastleLong &&
              move.fromSquare.isEquals(BoardSquare(baseRow, Board.COLUMN_A));
          return CastlingAvailability(canCastleShort, canCastleLong);
        }
      default:
        {
          return currentValue;
        }
    }
  }

  bool _isDoublePawnMove(Move move) {
    return board.getPieceAt(move.fromSquare)?.piece == Piece.Pawn &&
        (move.fromSquare.row - move.toSquare.row).abs() == 2;
  }

  int _updateHalfmoveClock(int currentValue, Move move) {
    if (board.getPieceAt(move.fromSquare)?.piece == Piece.Pawn ||
        board.getPieceAt(move.toSquare) != null) {
      return 0;
    } else {
      return currentValue + 1;
    }
  }
}
