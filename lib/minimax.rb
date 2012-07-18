class Minimax
  def score(board,player)
    score = 0
    score = 1 if board.winning_solution?(player)
    score
  end
end
