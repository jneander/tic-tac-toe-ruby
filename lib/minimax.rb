class Minimax
  attr_accessor :min_mark, :max_mark

  def score(board,mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)

    available_spaces = board.spaces_with_mark(Mark::BLANK)

    if score == 0 and not available_spaces.empty?
      score(board,mark)
    end

    score
  end
end
