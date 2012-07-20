class Minimax
  attr_accessor :min_mark, :max_mark

  def score(board,current_mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)

    if score == 0
      available_spaces = board.spaces_with_mark(Mark::BLANK)
      next_mark = current_mark == @min_mark ? @max_mark : @min_mark
      next_score = 0

      available_spaces.each {|space|
        board.make_mark(space,next_mark)
        next_score = score(board,current_mark)
        board.make_mark(space,Mark::BLANK)

        if (next_score > score and next_mark == @max_mark) or
          (next_score < score and next_mark == @min_mark) or
          (space == available_spaces.first)
          score = next_score
        end
      }
    end

    score
  end
end
