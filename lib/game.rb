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
        @console.display_board_choices(@board)
        chosen_space = @players.first.choose_move(@board)
        @board.make_mark(chosen_space, @players.first)
        @players.rotate!
      end
      @console.display_game_winner(1)
      @console.display_game_results(@board)
      keep_playing = @console.prompt_play_again
    end
  end

  def over?
    @board.winning_solution?(*@players) ||
      @board.spaces_with_mark(Board::BLANK).empty?
  end

  def set_players
    @config.choose_player
    @config.choose_opponent
    @players = @config.players.clone
    @console.assign_marks(@config.assigned_symbols)
    @console.set_players(@players)
  end
end
