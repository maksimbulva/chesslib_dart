import 'package:chesslib_dart/core/engine/board/board.dart';
import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/colored_piece.dart';
import 'package:chesslib_dart/core/engine/fen/fen_format.dart';
import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';
import 'package:chesslib_dart/core/engine/position/castling_availability.dart';
import 'package:chesslib_dart/core/engine/position/position.dart';

class FenDecoder {
  // Decodes chess positions into Forsyth–Edwards notation format
  Position decode(String encoded) {
    final splitted = encoded.split(' ');
    final board = _decodeBoard(splitted[0]);
    final playerToMove = _decodePlayerToMove(splitted[1]);

    final whiteCastlingAvailability =
        _decodeCastlingAvailability(splitted[2], Player.White);
    final blackCastlingAvailability =
        _decodeCastlingAvailability(splitted[2], Player.Black);

    final enPassantCaptureColumn =
        _decodeEnPassantCaptureAvailability(splitted[3]);

    final halfMoveClock = (splitted.length > 4) ? int.parse(splitted[4]) : 0;
    final fullMoveNumber = (splitted.length > 5) ? int.parse(splitted[5]) : 0;

    return Position(
        board,
        playerToMove,
        whiteCastlingAvailability,
        blackCastlingAvailability,
        enPassantCaptureColumn,
        halfMoveClock,
        fullMoveNumber);
  }

  Board _decodeBoard(String encoded) {
    final encodedRows = encoded.split(FenFormat.ROW_SEPARATOR);
    assert(encodedRows.length == Board.ROW_COUNT);

    final decodedPieces = List<ColoredPiece?>.empty(growable: true);
    for (var encodedRow in encodedRows.reversed) {
      for (var i = 0; i < encodedRow.length; ++i) {
        final currentChar = encodedRow[i];
        final coloredPiece = _decodeColoredPiece(currentChar);
        if (coloredPiece != null) {
          decodedPieces.add(coloredPiece);
        } else {
          final numberOfEmptySquares = int.parse(currentChar);
          decodedPieces
              .addAll(List<ColoredPiece?>.filled(numberOfEmptySquares, null));
        }
      }
    }

    return Board(decodedPieces);
  }

  Player _decodePlayerToMove(String encoded) {
    switch (encoded.toLowerCase()) {
      case FenFormat.BLACK_TO_MOVE:
        {
          return Player.Black;
        }
      case FenFormat.WHITE_TO_MOVE:
        {
          return Player.White;
        }
      default:
        {
          throw Exception('Failed to decode player from $encoded');
        }
    }
  }

  CastlingAvailability _decodeCastlingAvailability(
      String encoded, Player player) {
    if (player == Player.Black) {
      final canCastleShort = encoded.contains(FenFormat.BLACK_CAN_CASTLE_SHORT);
      final canCastleLong = encoded.contains(FenFormat.BLACK_CAN_CASTLE_LONG);
      return CastlingAvailability(canCastleShort, canCastleLong);
    } else {
      final canCastleShort = encoded.contains(FenFormat.WHITE_CAN_CASTLE_SHORT);
      final canCastleLong = encoded.contains(FenFormat.WHITE_CAN_CASTLE_LONG);
      return CastlingAvailability(canCastleShort, canCastleLong);
    }
  }

  int? _decodeEnPassantCaptureAvailability(String encoded) {
    if (encoded == FenFormat.CANNOT_CAPTURE_EN_PASSANT) {
      return null;
    }
    return BoardSquare.of(encoded).column;
  }

  ColoredPiece? _decodeColoredPiece(String encodedPiece) {
    assert(encodedPiece.length == 1);
    final player = (encodedPiece.toUpperCase() == encodedPiece)
        ? Player.White
        : Player.Black;

    final piece = _decodePiece(encodedPiece);
    return (piece == null) ? null : ColoredPiece(player, piece);
  }

  Piece? _decodePiece(String encodedPiece) {
    switch (encodedPiece.toLowerCase()) {
      case 'p':
        {
          return Piece.Pawn;
        }
      case 'n':
        {
          return Piece.Knight;
        }
      case 'b':
        {
          return Piece.Bishop;
        }
      case 'r':
        {
          return Piece.Rook;
        }
      case 'q':
        {
          return Piece.Queen;
        }
      case 'k':
        {
          return Piece.King;
        }
      default:
        {
          return null;
        }
    }
  }
}
