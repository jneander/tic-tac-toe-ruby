require 'human'
require 'computer_dumb'
require 'computer_impossible'

class Configuration
  attr_reader :console, :players

  PLAYER_CLASSES = [Human, DumbComputer, ImpossibleComputer]

  def initialize(console)
    @console = console
    @players = []
  end

  def choose_player
    @players = [Human.new]
  end

  def choose_opponent
    @console.prompt_opponent_type(PLAYER_CLASSES)
  end
end
