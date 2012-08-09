require 'human'

describe Human do
  before :all do
    @player = Human.new
  end

  before :each do
    @console = mock("console").as_null_object
    @board = mock("board").as_null_object
    @player.console = @console
  end

  it "#choose_move requests input from the console" do
    @console.should_receive(:prompt_player_mark).and_return(0)
    @player.choose_move(@board)
  end

  it "#choose_move passes indices of available spaces to console" do
    @board.stub!(:spaces_with_mark).and_return([1, 2, 3, 4])
    @console.should_receive(:prompt_player_mark).with([1, 2, 3, 4])
    @player.choose_move(@board)
  end

  it "converts the class to a string" do
    Human.to_s.should == "Human"
  end

  it "stores a symbol in 'symbol' attribute" do
    @player.symbol = :test_sym
  end
end
