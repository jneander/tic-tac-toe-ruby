require 'human'
require 'computer_dumb'
require 'computer_impossible'

class Configuration
  attr_reader :console, :players, :assigned_marks

  PLAYER_CLASSES = [Human, DumbComputer, ImpossibleComputer]

  def initialize(console)
    @console = console
    @players = []
    @assigned_marks = {}
  end

  def choose_player
    @players << Human.new
  end

  def choose_opponent
    @players << @console.prompt_opponent_type(PLAYER_CLASSES).new
  end
end
