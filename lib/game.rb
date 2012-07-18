require 'board_factory'
require 'human'
require 'computer_dumb'

class Game
  attr_accessor :board, :players, :console, :player_types

  def initialize(console)
    @board = BoardFactory.create
    @console = console
    @player_types = [Human,DumbComputer]
    @players = []
  end

  def run
    set_players
    until over?
      @console.display_board(@board)
      @players.first.make_mark(@board)
      @players.rotate!
    end
    @console.display_game_results(@board)
  end

  def over?
    @board.winning_solution?(*@players) ||
      @board.spaces_with_mark(Mark::BLANK).empty?
  end

  private
  def set_players
    @players << @player_types.first.new
    opponent_type = @console.prompt_opponent_type(@player_types)
    @players << opponent_type.new
    @players.each {|player| player.console = @console}
    @console.set_players(@players)
  end
end
