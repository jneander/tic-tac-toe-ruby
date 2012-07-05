$: << File.join(File.expand_path(File.dirname(__FILE__)), "/lib")
require 'board'

describe Board do
  before :each do
    @board = Board.new(3)
  end

  it "returns the size of the board" do
    @board.size.should eql 3
  end
end
