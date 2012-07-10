require 'player_factory'

class Game
  attr_accessor :board, :players

  def initialize(console)
    @console = console
    @players = [nil,nil].collect {PlayerFactory.create}
    @players.each {|player| player.console = @console}
  end

  def run
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
end
