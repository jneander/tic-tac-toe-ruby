class Human
  attr_accessor :console

  def make_mark(board)
    index = choose_move(board)
    board.make_mark(index,self)
  end

  def choose_move(board)
    index = @console.prompt_player_mark
    while not board.space_available?(index)
      @console.alert_space_unavailable(index)
      index = @console.prompt_player_mark
    end
    index
  end

  def self.to_s
    "Human"
  end
end
