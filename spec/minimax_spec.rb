require 'minimax'
require 'board'

describe Minimax do
  before :all do
    @minimax = Minimax.new
    @minimax.max_mark = :max_mark
    @minimax.min_mark = :min_mark
  end

  it "returns 1 for max_mark win" do
    @board = Board.new
    @board.stub!(:winning_solution?).with(:min_mark).and_return(false)
    @board.stub!(:winning_solution?).with(:max_mark).and_return(true)
    @minimax.score(@board,:max_mark).should == 1
  end
end
