import 'package:chesslib_dart/core/engine/piece.dart';
import 'package:chesslib_dart/core/engine/player.dart';
import 'package:quiver/core.dart';

class ColoredPiece {
  final Player player;
  final Piece piece;

  ColoredPiece(this.player, this.piece);

  @override
  bool operator ==(Object other) {
    return other is ColoredPiece &&
        player == other.player &&
        piece == other.piece;
  }

  @override
  int get hashCode {
    return hash2(player, piece);
  }

  @override
  String toString() {
    return '$player $piece';
  }
}
