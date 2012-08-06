require 'human'
require 'computer_dumb'
require 'computer_impossible'
require 'board'

class Configuration
  attr_reader :console, :players, :assigned_symbols, :board

  PLAYER_CLASSES = [Human, DumbComputer, ImpossibleComputer]
  BOARD_SIZES = [3, 4]

  def initialize(console)
    @console = console
    @players = []
    @assigned_symbols = {}
  end

  def setup
    choose_player
    choose_opponent
    choose_board
    assign_symbols
    assign_marks
    assign_order
  end

  def choose_player
    @players[0] = Human.new
    @players[0].console = @console
  end

  def choose_opponent
    @players[1] = @console.prompt_opponent_type(PLAYER_CLASSES).new
    @players[1].console = @console
  end

  def choose_board
    size = @console.prompt_board_size
    @board = Board.new(size)
  end

  def assign_symbols
    @players.each_with_index do |player, index|
      @assigned_symbols["player#{index}".to_sym] = player
    end
  end

  def assign_marks
    @console.assign_marks(@assigned_symbols)
  end

  def assign_order
    order = @console.prompt_player_order
    @players.each_index do |index| 
      @players[index] = @assigned_symbols[order[index]]
    end
  end
end
