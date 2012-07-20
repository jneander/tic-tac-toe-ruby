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

  it "marks the board with opposing mark, then restores mark" do
    @board.stub!(:spaces_with_mark).and_return([3])
    @board.should_receive(:make_mark).with(3,:min_mark).once
    @board.should_receive(:make_mark).with(3,Mark::BLANK).once
    limit_recursion_using_winning_solution(1)
    @minimax.score(@board,:max_mark)
  end

  it "calls 'score' for each available space on board" do
    set_should_receive_marks([[2,:min_mark],[3,:min_mark]])
    @board.stub!(:winning_solution?).and_return(false)
    @board.stub!(:spaces_with_mark).and_return([2,3],[],[])
    @minimax.score(@board,:max_mark)
  end

  context "when comparing recursive scores" do
    before :each do
      set_winning_solutions_with(:max_mark,[false]*3 + [true])
      set_winning_solutions_with(:min_mark,[false]*2 + [true] + [false])
      @board.should_receive(:spaces_with_mark)
      .and_return([1,2,3],[])
    end

    it "returns highest score if opponent is max_mark" do
      @minimax.score(@board,:min_mark).should == 1
    end

    it "returns lowest score if opponent is min_mark" do
      @minimax.score(@board,:max_mark).should == -1
    end
  end

  private
  def limit_recursion_using_winning_solution(limit)
    returns = [false]*(limit * 2 + 1) + [true]
    @board.stub!(:winning_solution?).and_return(*returns)
  end

  def set_should_receive_marks(calls)
    calls.each {|space,mark|
      @board.should_receive(:make_mark).with(space,mark)
      @board.should_receive(:make_mark).with(space,Mark::BLANK)
    }
  end

  def set_winning_solutions_with(mark,solutions)
    @board.should_receive(:winning_solution?).with(mark)
    .and_return(*solutions)
  end
end
