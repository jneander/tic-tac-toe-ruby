require 'human'
require 'computer_dumb'

module PlayerFactory
  TYPES = [Human,DumbComputer]

  def self.create(index)
    TYPES[index].new if (0...TYPES.length).include?(index)
  end
end
