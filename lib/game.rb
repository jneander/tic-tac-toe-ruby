class Game
  attr_accessor :board, :players

  def initialize(console)
    @console = console
    @players = []
  end

  def run
    while not over?
      @console.display_board(@board)
      @players.first.make_mark(@board)
    end
  end

  def over?
    @board.winning_solution?(*@players) || @board.spaces_with_mark(:blank).empty?
  end
end
