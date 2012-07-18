require 'minimax'

describe Minimax do
  before :all do
    @solver = Minimax.new
  end
  
  before :each do
    @player1 = mock("Player")
    @board = mock("Board")
  end

  it "scores high on winning move" do
    @board.should_receive(:winning_solution?).with(@player1).and_return(true)
    @solver.score(@board,@player1).should == 1
  end

  it "scores zero on non-winning move" do
    @board.stub!(:winning_solution?).and_return(false)
    @solver.score(@board,@player1).should == 0
  end
end
