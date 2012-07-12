require 'player_factory'
require 'human'

describe PlayerFactory do
  it "creates a Human instance" do
    PlayerFactory.create.should be_instance_of(Human)
  end

  it "contains a list of available player types" do
    PlayerFactory::TYPES.should eql [Human,DumbComputer]
  end
end
