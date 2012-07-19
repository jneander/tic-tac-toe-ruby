require 'minimax'
require 'board'

describe Minimax do
  before :all do
    @solver = Minimax.new
  end
  
  before :each do
    @board = Board.new
    @min_mark = mock("Player")
    @max_mark = mock("Player")
    @solver.min_mark = @min_mark
    @solver.max_mark = @max_mark
  end

  it "scores high on winning mark" do
    @board.should_receive(:winning_solution?).with(@max_mark)
      .and_return(true)
    @board.should_receive(:winning_solution?).with(@min_mark)
      .and_return(false)
    @solver.score(@board,@max_mark).should == 1
  end

  it "scores zero on non-winning mark" do
    set_no_winning_solution
    @board.stub!(:spaces_with_mark).and_return([])
    @solver.score(@board,@max_mark).should == 0
  end

  it "scores low on opponent's winning mark" do
    @board.should_receive(:winning_solution?).with(@max_mark)
      .and_return(false)
    @board.should_receive(:winning_solution?).with(@min_mark)
      .and_return(true)
    @solver.score(@board,@min_mark).should == -1
  end

  it "makes mark if no solution but spaces available" do
    set_no_winning_solution
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[])
    @board.should_receive(:make_mark).any_number_of_times
    @solver.score(@board,@min_mark)
  end

  it "calls 'score' recursively until no spaces available" do
    set_no_winning_solution
    @board.should_receive(:spaces_with_mark)
      .and_return([1,2],[2],[],[1],[])
    @solver.score(@board,@min_mark)
  end

  it "calls 'score' recursively until a winning solution exists" do
    set_recursion_limit_before_solution(2)
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[2,3],[3],[])
    @solver.score(@board,@min_mark)
  end

  it "rotates marks between levels of recursion" do
    set_recursion_limit_before_solution(3)
    mark_order = []
    @board.stub!(:spaces_with_mark).and_return([1],[2],[3],[])
    @board.stub!(:make_mark) {|space,mark|
      mark_order << mark if mark != Mark::BLANK
    }
    @solver.score(@board,@min_mark)
    mark_order.should == [@max_mark,@min_mark,@max_mark]
  end

  it "completes with board in original state" do
    original_spaces = @board.spaces_with_mark(Mark::BLANK)
    set_recursion_limit_before_solution(1)
    @solver.score(@board,@min_mark)
    current_spaces = @board.spaces_with_mark(Mark::BLANK)
    current_spaces.should == original_spaces
  end

  it "tries all available spaces at each level of recursion" do
    space_order = []
    set_no_winning_solution
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[],[],[])
    @board.stub!(:make_mark) {|space,mark|
      space_order << space if mark != Mark::BLANK
    }
    @solver.score(@board,@min_mark)
    space_order.should == [1,2,3]
  end

  it "returns the highest score for max_mark" do
    @board.stub!(:winning_solution?).with(@max_mark)
      .and_return(false,false,true,false)
    @board.stub!(:winning_solution?).with(@min_mark)
      .and_return(false,false,false,true)
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[])
    @solver.score(@board,@max_mark).should == 1
  end

  it "returns the lowest score for min_mark" do
    @board.stub!(:winning_solution?).with(@min_mark)
      .and_return(false,false,true,false)
    @board.stub!(:winning_solution?).with(@max_mark)
      .and_return(false,false,false,true)
    @board.stub!(:spaces_with_mark).and_return([1,2,3],[])
    @solver.score(@board,@min_mark).should == -1
  end

  it "returns low score when opponent can win" do
    make_marks([1,4,5,6],@min_mark)
    make_marks([0,2,3,8],@max_mark)
    @solver.score(@board,@max_mark).should == -1
  end

  private
  def set_no_winning_solution
    @board.stub!(:winning_solution?).and_return(false)
  end

  def set_recursion_limit_before_solution(limit)
    @board.stub!(:winning_solution?)
    .and_return(*([false]*(limit*2+1) + [true]))
  end

  def make_marks(spaces,mark)
    spaces.each {|space| @board.make_mark(space,mark)}
  end
end
