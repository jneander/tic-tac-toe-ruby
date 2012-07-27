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

  it "requests prompt from console for opponent type selection" do
    @player2 = mock("Player")
    @console.should_receive(:prompt_opponent_type).
      with(Configuration::PLAYER_CLASSES).and_return(@player2)
    @config.choose_opponent
  end

  it "stores an instance of 'Human' in array 'players'" do
    @player1 = mock("Player")
    @config.choose_player
    @config.players.first.should be_instance_of(Human)
  end

  it "initializes with empty 'players' array" do
    @config.players.should == []
  end
end
