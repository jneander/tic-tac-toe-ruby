require 'player_factory'

class Game
  attr_accessor :board, :players

  def initialize(console)
    @console = console
    @players = [PlayerFactory.create, PlayerFactory.create]
  end

  def run
    verify_players
    while not over?
      @console.display_board(@board)
      @players.first.make_mark(@board)
      @players.rotate!
    end
    @console.display_game_results(@board)
  end

  def over?
    @board.winning_solution?(*@players) || @board.spaces_with_mark(:blank).empty?
  end

  private
  def verify_players
    raise "No players have been added to the game" if @players.empty?
  end
end
