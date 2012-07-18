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

  it "scores high on winning move" do
    @board.should_receive(:winning_solution?).with(@max_player).and_return(true)
    @solver.score(@board,@max_player).should == 1
  end

  it "scores zero on non-winning move" do
    @board.stub!(:winning_solution?).and_return(false)
    @solver.score(@board,@max_player).should == 0
  end

  it "scores low on opponent's winning move" do
    @board.should_receive(:winning_solution?).with(@min_player).and_return(true)
    @solver.score(@board,@min_player).should == -1
  end
end
