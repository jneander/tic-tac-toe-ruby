class Minimax
  attr_accessor :min_mark, :max_mark

  def score(board,current_mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)

    available_spaces = board.spaces_with_mark(Mark::BLANK)
    next_mark = current_mark == @min_mark ? @max_mark : @min_mark

    if score == 0 and not available_spaces.empty?
      available_spaces.each {|space|
        board.make_mark(space,next_mark)
        score(board,current_mark)
        board.make_mark(space,Mark::BLANK)
      }
    end

    score
  end
end
