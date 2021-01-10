class CastlingAvailability {
  final bool canCastleShort;
  final bool canCastleLong;

  const CastlingAvailability(this.canCastleShort, this.canCastleLong);

  @override
  bool operator ==(o) {
    return o is CastlingAvailability &&
        canCastleShort == o.canCastleShort &&
        canCastleLong == o.canCastleLong;
  }

  @override
  int get hashCode {
    return (canCastleShort ? 1 : 0) + (canCastleLong ? 2 : 0);
  }

  static const CastlingAvailability NONE = CastlingAvailability(false, false);
  static const CastlingAvailability BOTH = CastlingAvailability(true, true);

  static const CastlingAvailability SHORT_ONLY =
      CastlingAvailability(true, false);

  static const CastlingAvailability LONG_ONLY =
      CastlingAvailability(false, true);
}
