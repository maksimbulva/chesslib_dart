import 'package:chesslib_dart/core/engine/board/board.dart';
import 'package:chesslib_dart/core/engine/board/board_square.dart';
import 'package:chesslib_dart/core/engine/colored_piece.dart';
import 'package:chesslib_dart/core/engine/fen/fen_decoder.dart';
import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';
import 'package:chesslib_dart/core/engine/position/castling_availability.dart';
import 'package:test/test.dart';

void main() {
  const initialPosition =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  const endgamePosition = '6k1/5p2/6p1/8/7p/8/6PP/6K1 b - - 0 0';

  test('decodeBoard', () {
    final decodedBoard = FenDecoder().decode(initialPosition).board;
    for (var row = 2; row < 6; ++row) {
      for (var column = Board.COLUMN_A; column <= Board.COLUMN_H; ++column) {
        expect(decodedBoard.isAtCoordinatesEmpty(row, column), true);
      }
    }

    expect(decodedBoard.getPieceAt(BoardSquare.of('a1')),
        ColoredPiece(Player.White, Piece.Rook));
    expect(decodedBoard.getPieceAt(BoardSquare.of('f1')),
        ColoredPiece(Player.White, Piece.Bishop));
    expect(decodedBoard.getPieceAt(BoardSquare.of('e2')),
        ColoredPiece(Player.White, Piece.Pawn));
    expect(decodedBoard.getPieceAt(BoardSquare.of('d4')), null);
    expect(decodedBoard.getPieceAt(BoardSquare.of('e8')),
        ColoredPiece(Player.Black, Piece.King));
    expect(decodedBoard.getPieceAt(BoardSquare.of('d8')),
        ColoredPiece(Player.Black, Piece.Queen));
    expect(decodedBoard.getPieceAt(BoardSquare.of('g8')),
        ColoredPiece(Player.Black, Piece.Knight));
  });

  test('decodePlayerToMove', () {
    expect(FenDecoder().decode(initialPosition).playerToMove, Player.White);
    expect(FenDecoder().decode(endgamePosition).playerToMove, Player.Black);
  });

  test('decodeCastlingAvailability', () {
    var position = FenDecoder().decode(initialPosition);
    expect(position.getCastlingAvailability(Player.White),
        CastlingAvailability.BOTH);
    expect(position.getCastlingAvailability(Player.Black),
        CastlingAvailability.BOTH);

    position = FenDecoder().decode(initialPosition.replaceAll('KQkq', 'Qk'));
    expect(position.getCastlingAvailability(Player.White),
        CastlingAvailability.LONG_ONLY);
    expect(position.getCastlingAvailability(Player.Black),
        CastlingAvailability.SHORT_ONLY);

    position = FenDecoder().decode(endgamePosition);
    expect(position.getCastlingAvailability(Player.White),
        CastlingAvailability.NONE);
    expect(position.getCastlingAvailability(Player.Black),
        CastlingAvailability.NONE);
  });

  test('decodeEnPassantCaptureAvailability', () {
    expect(FenDecoder().decode(initialPosition).isCanCaptureEnPassant, false);
    expect(FenDecoder().decode(endgamePosition).isCanCaptureEnPassant, false);

    expect(
        FenDecoder()
            .decode(
                'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1')
            .isCanCaptureEnPassant,
        true);
  });

  test('decodeMoveCounters', () {
    const encodedPosition =
        'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2';
    final decodedPosition = FenDecoder().decode(encodedPosition);
    expect(decodedPosition.halfMoveClock, 1);
    expect(decodedPosition.fullMoveNumber, 2);
  });
}
