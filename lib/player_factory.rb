require 'human'
require 'computer_dumb'

module PlayerFactory
  TYPES = [Human,DumbComputer]
  HUMAN = Human

  def self.create(type)
    type.new if TYPES.include? type
  end

  def self.TYPES
    TYPES
  end

  def self.HUMAN
    HUMAN
  end
end
