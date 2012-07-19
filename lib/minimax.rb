require 'mark'

class Minimax
  attr_accessor :max_mark, :min_mark

  def score(board,mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)
    if score == 0
      next_mark = @max_mark == mark ? @min_mark : @max_mark
      available_spaces = board.spaces_with_mark(Mark::BLANK)
      available_spaces.each do |space|
        board.make_mark(space,next_mark)
        next_score = score(board,next_mark)
        board.make_mark(space,Mark::BLANK)

        if (next_score > score and mark == @max_mark) or
          (next_score < score and mark == @min_mark) or
          (available_spaces.first == space)
          score = next_score
        end
      end
    end
    score
  end
end
