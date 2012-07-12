require 'player_factory'
require 'human'

describe PlayerFactory do
  it "creates a Human instance" do
    PlayerFactory.create.should be_instance_of(Human)
  end
end
