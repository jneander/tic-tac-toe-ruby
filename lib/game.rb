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
    @symbols = @config.assigned_symbols
    @players = @config.players.clone
  end

  def run
    until over?
      @console.display_board_choices(@board)
      current_player = @players.first
      chosen_space = current_player.choose_move(@board)
      @board.make_mark(chosen_space, @symbols.key(current_player))
      @players.rotate!
    end

    @console.display_board(@board)

    display_game_results
  end

  def over?
    @board.winning_solution?(*@symbols.keys) ||
      @board.spaces_with_mark(Board::BLANK).empty?
  end

  def display_game_results
    if @board.winning_solution?(*@symbols.keys)
      @console.display_game_winner(1)
    else
      @console.display_game_draw
    end
  end
end
