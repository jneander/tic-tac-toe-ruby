class MockPlayer
  attr_accessor :mark_requested

  def make_mark(board)
    @mark_requested = true
  end
end
