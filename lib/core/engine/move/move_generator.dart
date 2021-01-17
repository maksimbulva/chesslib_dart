import 'package:chesslib_dart/core/engine/board/Vector2.dart';
import 'package:chesslib_dart/core/engine/board/board.dart';
import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/move/move.dart';
import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';
import 'package:chesslib_dart/core/engine/position/position.dart';

class MoveGenerator {

  static final List<Piece> _pawnPromotions = [
    Piece.Queen,
    Piece.Rook,
    Piece.Bishop,
    Piece.Knight
  ];

  static final List<int> _pawnCaptureColumnDeltas = [-1, 1];

  static final List<Vector2> _knightDeltas = [
    Vector2(-1, -2),
    Vector2(1, -2),
    Vector2(-2, -1),
    Vector2(2, -1),
    Vector2(-2, 1),
    Vector2(2, 1),
    Vector2(-1, 2),
    Vector2(1, 2),
  ];

  List<Move> generateMoves(Position position) {
    final legalMoves = List<Move>.empty(growable: true);
    for (final move in _generatePseudoLegalMoves(position)) {
      final newPosition = position.playMove(move);
      final myKingBoardSquare =
        newPosition.board.getKingBoardSquare(position.playerToMove);
      if (myKingBoardSquare != null && !isAttacksCell(
          newPosition,
          newPosition.playerToMove,
          myKingBoardSquare
      )) {
        legalMoves.add(move);
      }
    }
    return legalMoves;
  }

  bool isAttacksCell(
      Position position,
      Player attacker,
      BoardSquare targetCell) {
    return false;
  }

  List<Move> _generatePseudoLegalMoves(Position position) {
    final moves = List<Move>.empty(growable: true);
    final board = position.board;
    final player = position.playerToMove;

    for (var row = 0; row < Board.ROW_COUNT; ++row) {
      for (var column = Board.COLUMN_A; column <= Board.COLUMN_H; ++column) {
        final coloredPiece = board.getPieceAtCoordinates(row, column);
        if (coloredPiece == null || coloredPiece.player != player) {
          continue;
        }
        final fromSquare = BoardSquare(row, column);
        switch (coloredPiece.piece) {
          case Piece.Pawn: {
            _appendPawnMoves(fromSquare, position, moves);
            break;
          }
          case Piece.Knight: {
            _appendMovesFromDeltas(fromSquare, _knightDeltas, position, moves);
            break;
          }
        }
      }
    }
    return moves;
  }

  void _appendPawnMoves(
      BoardSquare fromSquare,
      Position position,
      List<Move> moves
  ) {
    final board = position.board;
    final deltaRow = position.playerToMove == Player.Black ? -1 : 1;
    final destRow = fromSquare.row + deltaRow;
    final moveForwardSquare = BoardSquare(destRow, fromSquare.column);
    if (board.isEmpty(moveForwardSquare)) {
      _appendPawnMoveOrPromotions(fromSquare, moveForwardSquare, moves);

      if ((position.playerToMove == Player.Black && fromSquare.row == 6)
        || (position.playerToMove == Player.White && fromSquare.row == 1)) {
        final moveTwiceForward = BoardSquare(
            destRow + deltaRow,
            fromSquare.column
        );
        if (board.isEmpty(moveTwiceForward)) {
          moves.add(Move.byCoordinates(fromSquare, moveTwiceForward));
        }
      }
    }

    final otherPlayer = getOtherPlayer(position.playerToMove);
    for (final captureDeltaColumn in _pawnCaptureColumnDeltas) {
      final captureColumn = fromSquare.column + captureDeltaColumn;
      if (captureColumn >= Board.COLUMN_A && captureColumn <= Board.COLUMN_H) {
        final captureSquare = BoardSquare(
            fromSquare.row + deltaRow,
            fromSquare.column + captureDeltaColumn
        );
        if (board.isOccupiedByPlayer(captureSquare, otherPlayer)) {
          _appendPawnMoveOrPromotions(fromSquare, captureSquare, moves);
        }
      }
    }

    final enPassantCaptureColumn = position.enPassantCaptureColumn;
    if (enPassantCaptureColumn != null &&
        (fromSquare.column - enPassantCaptureColumn).abs() == 1 &&
        ((position.playerToMove == Player.Black && fromSquare.row == 3) ||
        (position.playerToMove == Player.White && fromSquare.row == 4))) {
      final captureSquare = BoardSquare(
          fromSquare.row + deltaRow,
          enPassantCaptureColumn
      );
      moves.add(Move.enPassantCapture(fromSquare, captureSquare));
    }
  }

  void _appendPawnMoveOrPromotions(
      BoardSquare fromSquare,
      BoardSquare destSquare,
      List<Move> moves
  ) {
    final destRow = destSquare.row;
    if (destRow == 0 || destRow == 7) {
      for (final promoteTo in _pawnPromotions) {
        moves.add(Move.promotion(fromSquare, destSquare, promoteTo));
      }
    } else {
      moves.add(Move.byCoordinates(fromSquare, destSquare));
    }
  }

  void _appendMovesFromDeltas(
      BoardSquare fromSquare,
      List<Vector2> deltas,
      Position position,
      List<Move> moves
  ) {
    for (final moveDelta in deltas) {
      final destSquare = moveDelta + fromSquare;
      if (destSquare == null) {
        continue;
      }
      if (!position.board.isOccupiedByPlayer(
          destSquare, position.playerToMove)) {
        moves.add(Move.byCoordinates(fromSquare, destSquare));
      }
    }
  }
}
