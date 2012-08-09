class DumbComputer
  attr_accessor :console, :symbol

  def choose_move(board)
    board.spaces_with_mark(Board::BLANK).sample
  end

  def self.to_s
    "Dumb Computer"
  end
end
