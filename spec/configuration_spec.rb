require 'configuration'
require 'human'
require 'computer_dumb'
require 'computer_impossible'

describe Configuration do
  before :all do
    @setup_sequence = [:choose_player, :choose_opponent, :assign_symbols, 
                       :assign_marks, :assign_order]
  end

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
    
    it "initializes with an empty 'assigned_symbols' map" do
      @config.assigned_symbols.should == {}
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

    it "#choose_player overwrites any existing player" do
      @config.choose_player
      original_player = @config.players[0]
      @config.choose_player
      @config.players[0].should_not == original_player
    end

    it "#choose_opponent overwrites any existing opponent" do
      @console.stub!(:prompt_opponent_type).and_return(Human)
      @config.choose_player
      @config.choose_opponent
      original_opponent = @config.players[1]
      @config.choose_opponent
      @config.players[1].should_not == original_opponent
    end

    it "stores a reference to the console in each player" do
      @console.stub!(:prompt_opponent_type).and_return(Human)
      @config.choose_player
      @config.choose_opponent
      @config.players.each do |player|
        player.console.should == @config.console
      end
    end
  end

  context "when assigning symbols" do
    before :each do
      mock_opponent_instance
      @config.choose_player
      @config.choose_opponent
      @config.assign_symbols
    end

    it "assigns symbols according to player index" do
      @config.assigned_symbols[:player0].should equal @config.players[0]
      @config.assigned_symbols[:player1].should equal @config.players[1]
    end

    it "assigns a unique symbol to each player" do
      @config.players.each do |player|
        @config.assigned_symbols.should have_value(player)
      end
    end
  end

  it "#setup calls 'setup' methods in sequence" do
    call_sequence = []
    @setup_sequence.each do |method|
      @config.should_receive(method) {call_sequence << method}
    end
    @config.setup
    call_sequence.should == @setup_sequence
  end

  it "#assign_marks assigns marks to the console" do
    setup_sequence_to(:assign_symbols)
    symbols = @config.assigned_symbols
    @console.should_receive(:assign_marks).with(symbols)
    @config.assign_marks
  end

  it "#assign_order orders the players without change" do
    setup_sequence_to(:assign_marks)
    original_order = @config.players.clone
    @console.should_receive(:prompt_player_order).
      and_return([:player0, :player1])
    @config.assign_order
    @config.players.should == original_order
  end

  it "#assign_order orders the players according to console marks" do
    setup_sequence_to(:assign_marks)
    original_order = @config.players.clone
    @console.stub!(:prompt_player_order).and_return([:player1, :player0])
    @config.assign_order
    @config.players.should == original_order.reverse
  end

  private
  def setup_sequence_to(method)
    seq = @setup_sequence.take(@setup_sequence.index(method))
    @console.stub!(:prompt_opponent_type).and_return(Human)
    seq.each {|method| @config.__send__(method)}
  end

  def mock_opponent_instance
    @player2 = mock("Player").as_null_object
    @console.stub!(:prompt_opponent_type).and_return(@player2)
    @player2.stub!(:new).and_return(@player2)
  end
end
