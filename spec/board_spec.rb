require 'mark'
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
    @board.spaces.length.should eql 9
    @board.spaces.each do |space|
      space.should eql Mark::BLANK
    end
  end

  it "accepts a mark" do
    @board.make_mark(0, :player)
    @board.spaces[0].should eql :player
  end

  it "returns an array of spaces with the specified mark" do
    target_spaces = [3,5,7,8]
    make_marks(target_spaces, :player)
    @board.spaces_with_mark(:player).should eql target_spaces
    @board.spaces_with_mark(Mark::BLANK).should eql (0..8).sort - target_spaces
  end

  it "returns false when no winning solution exists" do
    @board.winning_solution?(:player).should eql false
  end

  it "return true when a winning solution exists" do
    @board.solutions.each do |solution|
      make_marks(solution, :player)
      @board.winning_solution?(:player).should eql true
      make_marks(solution, Mark::BLANK)
      @board.winning_solution?(:player).should eql false
    end
  end

  it "returns true when checking multiple marks" do
    make_marks(@board.solutions.first, :player1)
    @board.winning_solution?(*[:player1,:player2]).should eql true
    @board.winning_solution?(:player1).should eql true
    @board.winning_solution?(:player2).should eql false
  end

  it "returns true if a queried space is valid and unmarked" do
    @board.make_mark(1,:player)
    @board.space_available?(0).should eql true
    @board.space_available?(1).should eql false
    @board.space_available?(-1).should eql false
  end

  def make_marks(indices, mark)
    indices.each do |num|
      @board.make_mark(num, mark)
    end
  end
end
