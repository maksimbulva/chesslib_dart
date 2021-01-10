enum Player { Black, White }

Player getOtherPlayer(Player player) {
  return (player == Player.Black) ? Player.White : Player.Black;
}
