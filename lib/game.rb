require 'board'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

class Game
  attr_accessor :board, :players, :console, :player_types

  def initialize(config)
    @board = Board.new
    @config = config
    @console = @config.console
    @player_types = [Human, DumbComputer, ImpossibleComputer]
    @players = []
  end

  def run
    keep_playing = true
    while keep_playing do
      @board.reset
      set_players
      until over?
        @console.display_board(@board)
        @players.first.make_mark(@board)
        @players.rotate!
      end
      @console.display_game_results(@board)
      keep_playing = @console.prompt_play_again
    end
  end

  def over?
    @board.winning_solution?(*@players) ||
      @board.spaces_with_mark(Board::BLANK).empty?
  end

  def set_players
    @players = []
    @players << @player_types.first.new
    opponent_type = @console.prompt_opponent_type(@player_types)
    @players << opponent_type.new
    @players.each {|player| player.console = @console}
    @console.set_players(@players)
  end
end
