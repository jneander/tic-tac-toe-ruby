class Human
  attr_accessor :console

  def make_mark(board)
    index = @console.prompt_player_mark
    while not board.space_available?(index)
      @console.alert_space_unavailable(index)
      index = @console.prompt_player_mark
    end
    board.make_mark(index,self)
  end
end
