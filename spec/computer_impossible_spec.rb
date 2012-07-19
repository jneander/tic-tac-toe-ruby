require 'computer_impossible'
require 'board'

describe ImpossibleComputer do
  before :each do
    @opponent = mock("Player")
    @board = Board.new
    @computer = ImpossibleComputer.new(@opponent)
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:spaces_with_mark).and_return([8],[])
    @computer.get_best_space(@board).should == 8
  end

  it "is initialized with an opponent" do
    @computer.opponent.should == @opponent
  end

  it "returns the winning space to mark" do
    [1,3,4,6].each {|space| @board.make_mark(space,:player)}
    [0,2,5].each {|space| @board.make_mark(space,@computer)}
    @computer.get_best_space(@board).should == 8
  end
end
