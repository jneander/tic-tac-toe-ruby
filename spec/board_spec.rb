$: << File.join(File.expand_path(File.dirname(__FILE__)), "/lib")
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
      space.should eql :blank
    end
  end

  it "accepts a mark" do
    @board.make_mark(0, :player)
    @board.spaces[0].should eql :player
  end

  it "returns an array of spaces with the specified mark" do
    target_spaces = [3,5,7,8]
    target_spaces.each do |num|
      @board.make_mark(num, :player)
    end
    @board.spaces_with_mark(:player).should eql target_spaces
    @board.spaces_with_mark(:blank).should eql (0..8).sort - target_spaces
  end
end
