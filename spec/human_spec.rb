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
    @console.should_receive("prompt_player_mark").and_return(0)
    @player.choose_move(@board)
  end

  it "#choose_move checks for valid mark information" do
    @console.stub!(:prompt_player_mark).and_return(0, 1)
    @board.should_receive(:space_available?).and_return(false, true)
    @player.choose_move(@board).should == 1
  end

  it "converts the class to a string" do
    Human.to_s.should == "Human"
  end
end
