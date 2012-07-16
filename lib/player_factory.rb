require 'human'
require 'computer_dumb'

module PlayerFactory
  TYPES = [Human,DumbComputer]

  def self.create(type)
    type.new if TYPES.include? type
  end
end
