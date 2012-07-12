require 'human'
require 'computer_dumb'

module PlayerFactory
  TYPES = [Human,DumbComputer]

  def self.create
    Human.new
  end
end
