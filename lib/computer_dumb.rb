class DumbComputer
  def make_mark(board)
    mark_index = board.spaces_with_mark(Mark::BLANK).sample
    board.make_mark(mark_index,self)
    mark_index
  end

  def self.to_s
    "Dumb Computer"
  end
end
