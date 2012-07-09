require 'mock_player'
require 'game'

describe Game do
  before :each do
    @board = Board.new(3)
    @console = stub("console")
    @game = Game.new(@console)
    @game.board = @board
    @player1 = MockPlayer.new
  end

  it "should not be over after creation" do
    @game.over?.should eql false
  end

  it "should end when the board has a winning solution" do
    @game.players << @player1
    [0,1,2].each do |index|
      @board.make_mark(index, @player1)
    end
    @game.over?.should eql true
  end

  it "should request a mark from the player" do
    @game.players << @player1
    @game.run
    @player1.mark_requested.should eql true
  end
end
