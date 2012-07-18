class Minimax
  attr_accessor :max_player, :min_player

  def score(board,player)
    score = 0
    score = 1 if board.winning_solution?(@max_player)
    score = -1 if board.winning_solution?(@min_player)
    score
  end
end
