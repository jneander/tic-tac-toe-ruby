require 'configuration'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

describe Configuration do
  before :each do
    @console = mock("Console")
    @config = Configuration.new(@console)
  end

  it "initializes with a 'Console' object" do
    @config.console.should equal @console
  end

  it "contains a list of available 'Player' classes" do
    Configuration::PLAYER_CLASSES.should == [Human, DumbComputer, ImpossibleComputer]
  end
end
