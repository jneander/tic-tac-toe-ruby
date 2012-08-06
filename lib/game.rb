require 'board'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

class Game
  attr_accessor :board, :players, :console

  def initialize(config)
    @board = config.board
    @config = config
    @console = @config.console
    @symbols = @config.assigned_symbols
    @players = @config.players.clone
  end

  def run
    until over?
      @console.display_board_choices(@board)
      current_player = @players.first
      move = current_player.choose_move(@board.clone) until valid_move?(move)
      @board.make_mark(move, @symbols.key(current_player))
      @players.rotate!
    end

    @console.display_board(@board)
    display_game_results
  end

  def over?
    @board.winning_solution?(*@symbols.keys) ||
      @board.spaces_with_mark(Board::BLANK).empty?
  end

  def winning_symbol
    @symbols.keys.select {|symbol| @board.winning_solution?(symbol)}.first
  end

  def valid_move?(index)
    @board.spaces_with_mark(Board::BLANK).include?(index)
  end

  def display_game_results
    if @board.winning_solution?(*@symbols.keys)
      @console.display_game_winner(winning_symbol)
    else
      @console.display_game_draw
    end
  end
end
