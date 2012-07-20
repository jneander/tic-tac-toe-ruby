class Minimax
  attr_accessor :min_mark, :max_mark

  def score(board,mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)
    score
  end
end
