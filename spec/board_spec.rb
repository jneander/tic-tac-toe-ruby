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
    @board.add_mark(0, :player)
    @board.spaces[0].should eql :player
  end
end
