require 'game'

describe Game do
  before :each do
    @console = stub("console")
    @game = Game.new(@console)
    @player1 = mock("player")
  end

  context "with new board" do
    before :each do
      @game.board = stub("board").as_null_object
      @game.board.stub(:winning_solution?).and_return(false)
      @game.board.stub(:spaces_with_mark).and_return([nil]*9)
    end

    it "is not over after creation" do
      @game.over?.should eql false
    end
  end

  context "while not over" do
    it "requests a mark from the player" do
      @game.players << @player1
      @player1.should_receive(:make_mark)
      @game.run
    end
  end

  context "with winning board" do
    it "ends when the board has a winning solution" do
      set_winning_board
      @game.over?.should eql true
    end
  end

  private
  def set_winning_board(mark = :player)
    @game.board = stub("board").as_null_object
    @game.board.stub!(:winning_solution?).and_return(true)
  end
end
