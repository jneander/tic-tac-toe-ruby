require 'computer_impossible'

describe ImpossibleComputer do
  before :each do
    @opponent = mock("Player")
    @board = mock("Board")
    @computer = ImpossibleComputer.new(@opponent)
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:spaces_with_mark).and_return([8])
    @computer.get_best_space(@board).should == 8
  end

  it "is initialized with an opponent" do
    @computer.opponent.should == @opponent
  end
end
