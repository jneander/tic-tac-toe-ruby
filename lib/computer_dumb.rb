class DumbComputer
  attr_accessor :console

  def make_mark(board)
    index = choose_move(board)
    board.make_mark(index,self)
  end

  def choose_move(board)
    board.spaces_with_mark(Board::BLANK).sample
  end

  def self.to_s
    "Dumb Computer"
  end
end
