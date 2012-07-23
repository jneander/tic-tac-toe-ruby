require 'computer_impossible'
require 'board'

describe ImpossibleComputer do
  before :all do
    @board = Board.new
    @opponent = :player
    @computer = ImpossibleComputer.new(@opponent)
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "is initialized with an opponent" do
    @computer.opponent.should == @opponent
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:winning_solution).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([8],[])
    @computer.get_best_space(@board).should == 8
  end
end
