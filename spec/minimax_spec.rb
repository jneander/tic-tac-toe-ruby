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

  context "with mocks" do
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
      marking_order = []
      @board.stub!(:spaces_with_mark).and_return([3])
      @board.should_receive(:make_mark).twice {|i,mark|
        marking_order << mark
      }
      limit_recursion_using_winning_solution(1)
      
      @minimax.score(@board,:max_mark)
      marking_order.should == [:min_mark, Mark::BLANK]
    end

    it "calls 'score' for each available space on board" do
      set_should_receive_marks([[2,:min_mark],[3,:min_mark]])
      @board.stub!(:winning_solution?).and_return(false)
      @board.stub!(:spaces_with_mark).and_return([2,3],[],[])
      @minimax.score(@board,:max_mark)
    end

    it "returns highest score if opponent is max_mark and won" do
      set_winning_solutions_with(:max_mark,[false]*3 + [true])
      set_winning_solutions_with(:min_mark,[false]*2 + [true] + [false])
      @board.should_receive(:spaces_with_mark).and_return([1,2,3],[])
      @minimax.score(@board,:min_mark).should == 1 
    end

    it "returns lowest score if opponent is min_mark and won" do
      set_winning_solutions_with(:max_mark,[false]*3 + [true])
      set_winning_solutions_with(:min_mark,[false]*2 + [true] + [false])
      @board.should_receive(:spaces_with_mark).and_return([1,2,3],[])
      @minimax.score(@board,:max_mark).should == -1
    end

    it "discards initialized value when comparing recursive scores" do
      set_winning_solutions_with(:max_mark,[false]*4)
      set_winning_solutions_with(:min_mark,[false] + [true]*3)
      @board.should_receive(:spaces_with_mark).and_return([1,2,3])
      @minimax.score(@board,:min_mark).should == -1
    end
  end

  context "without mocks" do
    before :each do
      @board = Board.new
    end

    it "returns 1 for max_mark win" do
      make_marks([0,1,2],:max_mark)
      @minimax.score(@board,:max_mark).should == 1
    end

    it "returns -1 for min_mark win" do
      make_marks([0,1,2],:min_mark)
      @minimax.score(@board,:min_mark).should == -1
    end

    it "returns 0 for no win and board full" do
      make_marks([0,2,3,5,7],:min_mark)
      make_marks([1,4,6,8],:max_mark)
      @minimax.score(@board,:max_mark).should == 0
    end

    it "calls 'score' recursively until board full" do
      each_space = (0..8).collect {|i| [i]}
      @board.stub!(:winning_solution?).and_return(false)
      @board.should_receive(:spaces_with_mark).and_return(*each_space,[])

      marking_order = []
      @board.stub!(:make_mark) {|space| marking_order << space}

      @minimax.score(@board, :min_mark)
      marking_order.should == (each_space + each_space.reverse).flatten
    end

    it "calls 'score' recursively until winning solution" do
      each_space = (0..8).collect {|i| [i]}
      @board.stub!(:spaces_with_mark).and_return(*each_space,[])
      limit_recursion_using_winning_solution(5)

      marking_order = []
      @board.stub!(:make_mark) {|space| marking_order << space}

      @minimax.score(@board, :min_mark)
      marking_order.should == [0,1,2,3,4,4,3,2,1,0]
    end

    it "returns a hash of spaces and scores" do
      make_marks([0, 2, 5], :max_mark)
      make_marks([1, 3, 4], :min_mark)
      expected = {6 => -1, 7 => 0, 8 => 1}
      @minimax.scores(@board, :max_mark).should == expected
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

  def make_marks(spaces,mark)
    spaces.each do |space| @board.make_mark(space,mark) end
  end
end
