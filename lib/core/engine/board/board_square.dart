class BoardSquare {
  static const List<String> _columnNames =
      ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  final int row;
  final int column;

  BoardSquare(this.row, this.column);

  BoardSquare.of(String notationString)
      : this(_rowOf(notationString[1]), _columnOf(notationString[0]));

  bool isEquals(BoardSquare other) {
    return row == other.row && column == other.column;
  }

  static int _rowOf(String rowChar) {
    final row = int.parse(rowChar) - 1;
    assert(row >= 0 && row < 8);
    return row;
  }

  static int _columnOf(String columnChar) {
    switch (columnChar) {
      case 'a':
        {
          return 0;
        }
      case 'b':
        {
          return 1;
        }
      case 'c':
        {
          return 2;
        }
      case 'd':
        {
          return 3;
        }
      case 'e':
        {
          return 4;
        }
      case 'f':
        {
          return 5;
        }
      case 'g':
        {
          return 6;
        }
      case 'h':
        {
          return 7;
        }
      default:
        {
          throw Exception('Cannot convert $columnChar to column value');
        }
    }
  }

  @override
  String toString() {
    return '${_columnNames[column]}${row + 1}';
  }
}
