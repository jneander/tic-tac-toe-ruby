require 'player_factory'
require 'human'

describe PlayerFactory do
  it "contains a list of available player types" do
    PlayerFactory::TYPES.should eql [Human,DumbComputer]
  end

  it "creates instances of Players according to input" do
    PlayerFactory.create(Human).should be_instance_of(Human)
    PlayerFactory.create(DumbComputer).should be_instance_of(DumbComputer)
    PlayerFactory.create(:not_in_list).should be_nil
  end

  it "contains a reference to the 'default' Human class" do
    PlayerFactory::HUMAN.should eql Human
  end
end
