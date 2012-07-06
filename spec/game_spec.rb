$: << File.join(File.expand_path(File.dirname(__FILE__), "/lib"))
require 'game'

describe Game do
  before :each do
    @board = Board.new(3)
    @game = Game.new
    @game.board = @board
    @game.players = [:player1,:player2]
  end

  it "should not be over after creation" do
    @game.over?.should eql false
  end

  it "should end when the board has a winning solution" do
    [0,1,2].each do |index|
      @board.make_mark(index, @game.players[0])
    end
    @game.over?.should eql true
  end
end
