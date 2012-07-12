require 'player_factory'
require 'human'

describe PlayerFactory do
  it "contains a list of available player types" do
    PlayerFactory::TYPES.should eql [Human,DumbComputer]
  end

  it "creates instances of Players based on the index of TYPES" do
    PlayerFactory.create(0).should be_instance_of(Human)
    PlayerFactory.create(1).should be_instance_of(DumbComputer)
    PlayerFactory.create(2).should be_nil
  end
end
