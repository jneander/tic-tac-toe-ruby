class DumbComputer
  attr_accessor :console

  def choose_move(board)
    board.spaces_with_mark(Board::BLANK).sample
  end

  def self.to_s
    "Dumb Computer"
  end
end
