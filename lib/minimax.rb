class Minimax
  def score(board,player)
    board.winning_solution?(player)
    return 1
  end
end
