require 'minimax'
require 'board'

describe Minimax do
  before :all do
    @minimax = Minimax.new
    @minimax.max_mark = :max_mark
    @minimax.min_mark = :min_mark
    @board = Board.new
  end

  it "returns 1 for max_mark win" do
    @board.stub!(:winning_solution?).with(:min_mark).and_return(false)
    @board.stub!(:winning_solution?).with(:max_mark).and_return(true)
    @minimax.score(@board,:max_mark).should == 1
  end

  it "returns -1 for min_mark win" do
    @board.stub!(:winning_solution?).with(:min_mark).and_return(true)
    @board.stub!(:winning_solution?).with(:max_mark).and_return(false)
    @minimax.score(@board,:max_mark).should == -1
  end
end
