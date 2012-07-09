class Player
  attr_accessor :console

  def make_mark(board)
    index = @console.prompt_player_mark
  end
end
