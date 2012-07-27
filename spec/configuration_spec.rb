require 'configuration'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

describe Configuration do
  before :each do
    @console = mock("Console")
    @config = Configuration.new(@console)
  end

  it "contains a list of available 'Player' classes" do
    Configuration::PLAYER_CLASSES.should == [Human, DumbComputer, ImpossibleComputer]
  end

  context "at instantiation" do
    it "initializes with a 'Console' object" do
      @config.console.should equal @console
    end

    it "initializes with empty 'players' array" do
      @config.players.should == []
    end
  end

  context "when choosing players" do
    before :each do
      @player2 = mock("Player").as_null_object
    end

    it "stores an instance of 'Human' in array 'players'" do
      @config.choose_player
      @config.players.first.should be_instance_of(Human)
    end

    it "requests prompt from console for opponent type selection" do
      @console.should_receive(:prompt_opponent_type).
        with(Configuration::PLAYER_CLASSES).and_return(@player2)
      @config.choose_opponent
    end

    it "stores an instance of the requested opponent type" do
      @console.stub!(:prompt_opponent_type).and_return(@player2)
      @player2.should_receive(:new).and_return(@player2)
      @config.choose_opponent
      @config.players.last.should equal @player2
    end
  end
end
