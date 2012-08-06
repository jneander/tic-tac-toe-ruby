require 'board'

describe Board do
  before :each do
    @board_size = 3
    @board = Board.new(@board_size)
  end

  it "returns the size of the board" do
    @board.size.should eql @board_size
  end

  it "initializes with 9 'blank' spaces for board size 3" do
    Board.new(3).spaces.should eql [Board::BLANK]*9
  end

  it "initializes with 16 'blank' spaces for board size 4" do
    Board.new(4).spaces.should eql [Board::BLANK]*16
  end

  it "initializes with default 'blank' symbol" do
    Board::BLANK.should == :blank
  end

  it "#initialize generates a set of winning solutions for board size 3" do
    board = Board.new(3)
    board.solutions.should == [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
    ]
  end

  it "#initialize generates a set of winning solutions for board size 4" do
    board = Board.new(4)
    board.solutions.should == [
      [0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15],
      [0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15],
      [0,5,10,15],[3,6,9,12]
    ]
  end

  it "accepts a mark" do
    @board.make_mark(0, :player)
    @board.spaces[0].should == :player
  end

  it "returns an array of spaces with the specified mark" do
    target_spaces = [3,5,7,8]
    make_marks(@board, target_spaces, :player)
    @board.spaces_with_mark(:player).should eql target_spaces
    expected_spaces = (0..8).to_a - target_spaces
    @board.spaces_with_mark(Board::BLANK).should eql expected_spaces
  end

  it "returns false when no winning solution exists" do
    @board.winning_solution?(:player).should == false
  end

  it "return true when a winning solution exists" do
    @board.solutions.each do |solution|
      make_marks(@board, solution, :player)
      @board.winning_solution?(:player).should == true
      make_marks(@board, solution, Board::BLANK)
      @board.winning_solution?(:player).should == false
    end
  end

  it "can check for winning solutions on multiple marks at once" do
    make_marks(@board, @board.solutions.first, :player1)
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
    make_marks(@board, [0,1,2,3,4], :player)
    @board.reset
    @board.spaces_with_mark(:player).should == []
    @board.spaces_with_mark(Board::BLANK).should == (0..8).to_a
  end

  it "#symbols_added is initialized to an empty array" do
    @board.symbols_added.should == []
  end

  it "#symbols_added stores player symbols added to the board" do
    make_marks(@board, [1,3], :player1)
    make_marks(@board, [0], :player2)
    @board.symbols_added.should == [:player2, :player1]
  end

  context "#clone" do
    before :all do
      @orig = Board.new
      make_marks(@orig, [1,2], :player1)
      make_marks(@orig, [3,4], :player2)
      @clone = @orig.clone
    end

    it "returns an instance of Board" do
      @clone.should be_a(Board)
    end

    it "transfers board size" do
      @clone.size.should == @orig.size
    end

    it "duplicates board spaces" do
      @clone.spaces.should == @orig.spaces
      @clone.spaces.should == @orig.spaces
      @clone.spaces.should_not equal @orig.spaces
    end

    it "duplicates board symbols_added" do
      @clone.symbols_added.should == @orig.symbols_added
      @clone.symbols_added.should_not equal @orig.symbols_added
    end
  end

  def make_marks(board, indices, mark)
    indices.each do |num|
      board.make_mark(num, mark)
    end
  end
end
