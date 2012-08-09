class Human
  attr_accessor :console, :symbol

  def choose_move(board)
    available_spaces = board.spaces_with_mark(Board::BLANK)
    @console.prompt_player_mark(available_spaces)
  end

  def self.to_s
    "Human"
  end
end
