require 'board'

describe Board do
  before :each do
    @board_size = 3
    @board = Board.new(@board_size)
  end

  it "returns the size of the board" do
    @board.size.should eql @board_size
  end

  it "initializes with 9 'blank' spaces" do
    @board.spaces.should eql [Board::BLANK]*9
  end

  it "initializes with default 'blank' symbol" do
    Board::BLANK.should == :blank
  end

  it "accepts a mark" do
    @board.make_mark(0, :player)
    @board.spaces[0].should == :player
  end

  it "returns an array of spaces with the specified mark" do
    target_spaces = [3,5,7,8]
    make_marks(target_spaces, :player)
    @board.spaces_with_mark(:player).should eql target_spaces
    expected_spaces = (0..8).to_a - target_spaces
    @board.spaces_with_mark(Board::BLANK).should eql expected_spaces
  end

  it "returns false when no winning solution exists" do
    @board.winning_solution?(:player).should == false
  end

  it "return true when a winning solution exists" do
    @board.solutions.each do |solution|
      make_marks(solution, :player)
      @board.winning_solution?(:player).should == true
      make_marks(solution, Board::BLANK)
      @board.winning_solution?(:player).should == false
    end
  end

  it "can check for winning solutions on multiple marks at once" do
    make_marks(@board.solutions.first, :player1)
    @board.winning_solution?(*[:player1,:player2]).should == true
    @board.winning_solution?(:player1).should == true
    @board.winning_solution?(:player2).should == false
  end

  it "returns true if a queried space is valid and unmarked" do
    @board.make_mark(1,:player)
    @board.space_available?(0).should == true
    @board.space_available?(1).should == false
    @board.space_available?(-1).should == false
  end

  it "#reset will set each space to BLANK mark" do
    make_marks([0,1,2,3,4], :player)
    @board.reset
    @board.spaces_with_mark(:player).should == []
    @board.spaces_with_mark(Board::BLANK).should == (0..8).to_a
  end

  it "#symbols_added is initialized to an empty array" do
    @board.symbols_added.should == []
  end

  it "#symbols_added stores player symbols added to the board" do
    make_marks([1,3], :player1)
    make_marks([0], :player2)
    @board.symbols_added.should == [:player2, :player1]
  end

  def make_marks(indices, mark)
    indices.each do |num|
      @board.make_mark(num, mark)
    end
  end
end
