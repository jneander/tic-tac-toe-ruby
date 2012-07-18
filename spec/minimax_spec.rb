require 'minimax'

describe Minimax do
  before :all do
    @solver = Minimax.new
  end
  
  before :each do
    @min_player = mock("Player")
    @max_player = mock("Player")
    @board = mock("Board").as_null_object
    @solver.min_player = @min_player
    @solver.max_player = @max_player
  end

  it "scores high on winning mark" do
    @board.should_receive(:winning_solution?).with(@max_player).and_return(true)
    @solver.score(@board,@max_player).should == 1
  end

  it "scores zero on non-winning mark" do
    @board.stub!(:winning_solution?).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([])
    @solver.score(@board,@max_player).should == 0
  end

  it "scores low on opponent's winning mark" do
    @board.should_receive(:winning_solution?).with(@min_player).and_return(true)
    @solver.score(@board,@min_player).should == -1
  end

  it "makes mark if no solution but spaces available" do
    @board.stub!(:winning_solution?).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[])
    @board.should_receive(:make_mark) {|space| space.should == 1}
    @solver.score(@board,@min_player)
  end

  it "calls 'score' recursively until no spaces available" do
    @board.stub!(:winning_solution?).and_return(false)
    @board.should_receive(:spaces_with_mark).and_return([1,2,3],[2,3],[3],[])
    @solver.score(@board,@min_player)
  end
end
