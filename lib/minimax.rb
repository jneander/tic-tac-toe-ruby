require 'mark'

class Minimax
  attr_accessor :max_player, :min_player

  def score(board,player)
    score = 0
    score = 1 if board.winning_solution?(@max_player)
    score = -1 if board.winning_solution?(@min_player)
    if score == 0
      next_player = @max_player == player ? @min_player : @max_player
      available_spaces = board.spaces_with_mark(Mark::BLANK)
      if available_spaces.length > 0
        board.make_mark(available_spaces[0],next_player)
        score = score(board,next_player)
        board.make_mark(available_spaces[0],Mark::BLANK)
      end
    end
    score
  end
end
