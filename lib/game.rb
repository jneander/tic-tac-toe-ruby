class Game
  attr_accessor :board, :players

  def initialize(console)
    @console = console
    @players = []
  end

  def run
    @players.first.make_mark(@board)
  end

  def over?
    @board.winning_solution?(*@players) || @board.spaces_with_mark(:blank).empty?
  end
end
