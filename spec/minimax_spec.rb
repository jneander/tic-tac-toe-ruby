require 'minimax'
require 'board'

describe Minimax do
  before :all do
    @minimax = Minimax.new
    @minimax.max_mark = :max_mark
    @minimax.min_mark = :min_mark
  end
  
  before :each do
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

  it "returns 0 for no win and board full" do
    @board.stub!(:winning_solution?).and_return(false)
    @board.stub!(:spaces_with_mark).with(Mark::BLANK).and_return([])
    @minimax.score(@board,:max_mark).should == 0
  end

  it "calls 'score' recursively until board full" do
    @board.stub!(:winning_solution?).and_return(false)
    @board.should_receive(:spaces_with_mark).and_return([0],[])
    @minimax.score(@board,:max_mark)
  end

  it "calls 'score' recursively until winning solution" do
    limit_recursion_using_winning_solution(2)
    @board.stub!(:spaces_with_mark).and_return([0])
    @minimax.score(@board,:max_mark)
  end

  it "marks the board with opposing mark" do
    @board.stub!(:spaces_with_mark).and_return([3])
    @board.should_receive(:make_mark).with(3,:min_mark).once
    limit_recursion_using_winning_solution(1)
    @minimax.score(@board,:max_mark)
  end

  private
  def limit_recursion_using_winning_solution(limit)
    returns = [false]*(limit * 2 + 1) + [true]
    @board.stub!(:winning_solution?).and_return(*returns)
  end
end
