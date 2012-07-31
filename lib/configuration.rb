require 'human'
require 'computer_dumb'
require 'computer_impossible'

class Configuration
  attr_reader :console, :players, :assigned_symbols

  PLAYER_CLASSES = [Human, DumbComputer, ImpossibleComputer]

  def initialize(console)
    @console = console
    @players = []
    @assigned_symbols = {}
  end

  def setup
    choose_player
    choose_opponent
    assign_symbols
  end

  def choose_player
    @players[0] = Human.new
    @players[0].console = @console
  end

  def choose_opponent
    @players[1] = @console.prompt_opponent_type(PLAYER_CLASSES).new
    @players[1].console = @console
  end

  def assign_symbols
    @players.each_with_index do |player, index|
      @assigned_symbols["player#{index}".to_sym] = player
    end
  end

  def assign_marks
    @console.assign_marks(@assigned_symbols)
  end
end
