$: << File.join(File.expand_path(File.dirname(__FILE__)), "/lib")
require 'board'

describe Board do
  before :each do
    @board = Board.new
  end
end
