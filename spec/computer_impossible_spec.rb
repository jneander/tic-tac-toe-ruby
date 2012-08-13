require 'computer_impossible'
require 'board'
require 'minimax'

describe ImpossibleComputer do
  before :all do
    @opponent = :player
    @computer = ImpossibleComputer.new
    @computer.symbol = :computer
  end

  before :each do
    @board = Board.new
  end

  it "#initialize creates and stores a Minimax object" do
    @computer.minimax.should be_instance_of(Minimax)
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "#get_opponent_symbol returns default symbol :opponent" do
    @computer.get_opponent_symbol(@board).should == :opponent
  end

  it "#get_opponent_symbol returns the opposing symbol" do
    @board.make_mark(1, :player2)
    @computer.get_opponent_symbol(@board).should == :player2
  end

  it "#choose_move sets 'minimax.min_mark' to default value" do
    @computer.minimax.stub!(:scores).and_return([1])
    @computer.choose_move(@board)
    @computer.minimax.min_mark.should eql :opponent
  end

  it "#choose_move sets 'minimax.max_mark' to symbol" do
    @computer.symbol = :test_sym
    @computer.minimax.stub!(:scores).and_return([1])
    @computer.choose_move(@board)
    @computer.minimax.max_mark.should == @computer.symbol
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:winning_solution).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([8],[])
    @computer.choose_move(@board).should eql 8
  end

  it "returns the winning space to mark" do
    [0, 2, 5].each {|space| @board.make_mark(space, @computer.symbol)}
    [1, 3, 4].each {|space| @board.make_mark(space, @opponent)}
    @computer.choose_move(@board).should eql 8
  end

  it "returns the only non-losing mark after player begins" do
    @board.make_mark(0, @opponent)
    @computer.choose_move(@board).should eql 4
  end

  it "stores a symbol in 'symbol' attribute" do
    @computer.symbol = :test_sym
  end

  it "#choose_move sets the depth limit on minimax" do
    @computer.minimax.stub!(:scores).and_return({1 => 2})
    @computer.choose_move(@board)
    @computer.minimax.depth_limit.should == 10
  end
end
