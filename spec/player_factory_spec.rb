require 'player_factory'
require 'player'

describe PlayerFactory do
  it "creates a Player instance" do
    @console = mock("console")
    PlayerFactory.create.should be_instance_of(Player)
  end
end
