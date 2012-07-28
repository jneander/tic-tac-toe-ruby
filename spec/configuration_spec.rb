require 'configuration'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

describe Configuration do
  before :each do
    @console = mock("Console").as_null_object
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
    
    it "initializes with an empty 'assigned_marks' map" do
      @config.assigned_marks.should == {}
    end
  end

  context "when choosing players" do
    before :each do
      mock_opponent_instance
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
      mock_opponent_instance
      @config.choose_opponent
      @config.players.last.should equal @player2
    end
  end

  it "assigns a unique mark to each player" do
    mock_opponent_instance
    @config.choose_player
    @config.choose_opponent
    @config.assign_marks
    @config.players.each do |player|
      @config.assigned_marks.should have_value(player)
    end
  end

  private
  def mock_opponent_instance
    @player2 = mock("Player")
    @console.stub!(:prompt_opponent_type).and_return(@player2)
    @player2.stub!(:new).and_return(@player2)
  end
end
