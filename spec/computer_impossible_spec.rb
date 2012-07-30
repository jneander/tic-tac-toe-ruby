require 'computer_impossible'
require 'board'
require 'minimax'

describe ImpossibleComputer do
  before :all do
    @opponent = :player
    @computer = ImpossibleComputer.new
  end

  before :each do
    @board = Board.new
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "sets the marks on a Minimax object" do
    @computer.minimax.should be_instance_of(Minimax)
    @computer.minimax.max_mark.should equal @computer
  end

  it "#get_opponent_symbol returns default symbol :opponent" do
    @computer.get_opponent_symbol(@board).should == :opponent
  end

  it "#get_opponent_symbol returns the opposing symbol" do
    @board.make_mark(1, :player2)
    @computer.get_opponent_symbol(@board).should == :player2
  end

  it "#get_best_space sets 'minimax.min_mark' to default value" do
    @computer.minimax.stub!(:scores).and_return([1])
    @computer.get_best_space(@board)
    @computer.minimax.min_mark.should eql :opponent
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:winning_solution).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([8],[])
    @computer.get_best_space(@board).should eql 8
  end

  it "returns the winning space to mark" do
    [0, 2, 5].each {|space| @board.make_mark(space, @computer)}
    [1, 3, 4].each {|space| @board.make_mark(space, @opponent)}
    @computer.get_best_space(@board).should eql 8
  end

  it "makes a mark on the board" do
    (0..7).each do |space| @board.make_mark(space, :unavailable) end
    @computer.make_mark(@board)
    @board.spaces_with_mark(@computer).should eql [8]
  end

  it "returns the only non-losing mark after player begins" do
    @board.make_mark(0, @opponent)
    @computer.get_best_space(@board).should eql 4
  end
end
